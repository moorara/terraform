# ================================================================================
#  Misc
# ================================================================================

# https://www.terraform.io/docs/providers/aws/r/key_pair.html
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html
resource "aws_key_pair" "bastion" {
  key_name   = "${local.name}-bastion"
  public_key = file(var.bastion_public_key)
}

# ================================================================================
#  IAM
# ================================================================================

# https://www.terraform.io/docs/providers/aws/r/iam_instance_profile.html
# https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2_instance-profiles.html
resource "aws_iam_instance_profile" "bastion" {
  name = "${local.name}-bastion"
  role = aws_iam_role.bastion.name
}

# https://www.terraform.io/docs/providers/aws/r/iam_role.html
# https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html
resource "aws_iam_role" "bastion" {
  name = "${local.name}-bastion"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = merge(var.common_tags, map(
    "Name", format("%s-bastion", local.name),
  ))
}

# https://www.terraform.io/docs/providers/aws/r/iam_role_policy.html
resource "aws_iam_role_policy" "bastion" {
  name = "${local.name}-bastion"
  role = aws_iam_role.bastion.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

# ================================================================================
#  Security Group
# ================================================================================

# https://www.terraform.io/docs/providers/aws/r/security_group.html
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-network-security.html
resource "aws_security_group" "bastion" {
  name   = "${local.name}-bastion"
  vpc_id = aws_vpc.main.id

  # Incoming: ICMP inside the VPC
  ingress {
    to_port     = -1
    from_port   = -1
    protocol    = "icmp"
    cidr_blocks = [ aws_vpc.main.cidr_block ]
  }

  # Incoming: All protocols inside the VPC
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [ aws_vpc.main.cidr_block ]
  }

  # Incoming: SSH from trusted sources
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.trusted_cidrs
  }

  # Outgoing: All protocols to public Internet
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  /* egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [ "${aws_vpc.primary.cidr_block}" ]
  } */

  tags = merge(var.common_tags, var.region_tag, map(
    "Name", format("%s-bastion", local.name),
  ))

  # https://www.terraform.io/docs/configuration/resources.html#lifecycle-lifecycle-customizations
  lifecycle {
    create_before_destroy = true
  }
}

# ================================================================================
#  Launch Configurations
# ================================================================================

# https://www.terraform.io/docs/providers/aws/d/ami.html
# https://wiki.debian.org/Cloud/AmazonEC2Image
data "aws_ami" "debian" {
  most_recent = true
  owners      = [ "379101102735" ]

  filter {
    name   = "name"
    values = [ "debian-stretch-hvm-x86_64-gp2-*" ]
  }

  filter {
    name   = "virtualization-type"
    values = [ "hvm" ]
  }
}

# https://www.terraform.io/docs/providers/aws/r/launch_configuration.html
# https://docs.aws.amazon.com/autoscaling/ec2/userguide/LaunchConfiguration.html
resource "aws_launch_configuration" "bastion" {
  name                        = "${local.name}-bastion"
  image_id                    = data.aws_ami.debian.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.bastion.key_name
  iam_instance_profile        = aws_iam_instance_profile.bastion.id
  security_groups             = [ aws_security_group.bastion.id ]
  associate_public_ip_address = true

  # https://www.terraform.io/docs/configuration/resources.html#lifecycle-lifecycle-customizations
  lifecycle {
    create_before_destroy = true
  }
}

# ================================================================================
#  Auto Scaling Groups
# ================================================================================

# https://www.terraform.io/docs/providers/aws/r/autoscaling_group.html
# https://docs.aws.amazon.com/autoscaling/ec2/userguide/AutoScalingGroup.html
resource "aws_autoscaling_group" "bastion" {
  name                 = "${local.name}-bastion"
  min_size             = 1
  max_size             = 1
  desired_capacity     = 1
  launch_configuration = aws_launch_configuration.bastion.name
  vpc_zone_identifier  = slice(aws_subnet.public.*.id, 0, local.az_len)

  tags = [
    for k, v in merge(var.common_tags, var.region_tag, { "Name": "${local.name}-bastion" }): {
      key                 = k
      value               = v
      propagate_at_launch = true
    }
  ]

  # https://www.terraform.io/docs/configuration/resources.html#lifecycle-lifecycle-customizations
  lifecycle {
    create_before_destroy = true
  }
}
