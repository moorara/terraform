# https://www.terraform.io/docs/providers/aws/d/ami.html
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

# https://www.terraform.io/docs/providers/aws/r/key_pair.html
resource "aws_key_pair" "bastion" {
  key_name   = "${var.name}-${var.environment}-bastion"
  public_key = "${file("${path.module}/${var.environment}-bastion.pub")}"
}

# https://www.terraform.io/docs/providers/aws/r/iam_instance_profile.html
resource "aws_iam_instance_profile" "bastion" {
  name = "${var.name}-${var.environment}-bastion"
  role = "${aws_iam_role.bastion.name}"
}

# https://www.terraform.io/docs/providers/aws/r/iam_role.html
resource "aws_iam_role" "bastion" {
  name = "${var.name}-${var.environment}-bastion"

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

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.name}-bastion",
    )
  )}"
}

# https://www.terraform.io/docs/providers/aws/r/iam_role_policy.html
resource "aws_iam_role_policy" "bastion" {
  name = "${var.name}-${var.environment}-bastion"
  role = "${aws_iam_role.bastion.name}"

  # TODO: restrict access for S3 buckets
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
    },
    {
      "Action": [
        "s3:ListBucket",
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "${aws_cloudwatch_log_group.bastion.arn}"
    }
  ]
}
EOF
}

# https://www.terraform.io/docs/providers/aws/r/cloudwatch_log_group.html
resource "aws_cloudwatch_log_group" "bastion" {
  name              = "${var.name}-${var.environment}-bastion"
  retention_in_days = 30

  tags = "${merge(
    local.common_tags,
    map(
      "Name",   "${var.name}-bastion",
      "Region", "${var.region}"
    )
  )}"
}

# https://www.terraform.io/docs/providers/aws/r/launch_configuration.html
resource "aws_launch_configuration" "bastion" {
  name                        = "${var.name}-${var.environment}-bastion"
  image_id                    = "${data.aws_ami.debian.id}"
  instance_type               = "t2.micro"
  ebs_optimized               = false
  iam_instance_profile        = "${aws_iam_instance_profile.bastion.id}"
  security_groups             = [ "${aws_security_group.bastion.id}" ]
  key_name                    = "${aws_key_pair.bastion.key_name}"
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }
}

# https://www.terraform.io/docs/providers/aws/r/autoscaling_group.html
resource "aws_autoscaling_group" "bastion" {
  name                 = "${var.name}-${var.environment}-bastion"
  launch_configuration = "${aws_launch_configuration.bastion.name}"
  vpc_zone_identifier  = [ "${aws_subnet.primary.*.id}" ]
  termination_policies = [ "OldestInstance" ]

  min_size         = 1
  max_size         = 1
  desired_capacity = 1

  tag {
    key                 = "Name"
    value               = "${var.name}-bastion"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "${var.environment}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Region"
    value               = "${var.region}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Owner"
    value               = "${var.owner}"
    propagate_at_launch = true
  }

  tag {
    key                 = "GitCommit"
    value               = "${var.git_commit}"
    propagate_at_launch = true
  }

  tag {
    key                 = "GitBranch"
    value               = "${var.git_branch}"
    propagate_at_launch = true
  }

  tag {
    key                 = "GitRepo"
    value               = "${var.git_repo}"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# https://www.terraform.io/docs/providers/aws/r/security_group.html
resource "aws_security_group" "bastion" {
  name   = "${var.name}-${var.environment}-bastion"
  vpc_id = "${aws_vpc.primary.id}"

  ingress {
    to_port     = -1
    from_port   = -1
    protocol    = "icmp"
    cidr_blocks = [ "${aws_vpc.primary.cidr_block}" ]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [ "${aws_vpc.primary.cidr_block}" ]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks =  [ "${var.whitelist}" ]
  }

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

  tags = "${merge(
    local.common_tags,
    map(
      "Name",   "${var.name}-bastion",
      "Region", "${var.region}"
    )
  )}"

  lifecycle {
    create_before_destroy = true
  }
}
