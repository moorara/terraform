data "aws_ami" "debian" {
  most_recent = true
  owners = [ "379101102735" ]

  filter {
    name = "name"
    values = [ "debian-stretch-hvm-x86_64-gp2-*" ]
  }

  filter {
    name   = "virtualization-type"
    values = [ "hvm" ]
  }
}

resource "aws_key_pair" "bastion" {
  key_name = "main-bastion-${var.environment}"
  public_key = "${file("${path.module}/bastion-${var.environment}.pub")}"
}

resource "aws_security_group" "bastion" {
  name = "main-bastion-${var.environment}"
  vpc_id = "${aws_vpc.main.id}"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "${aws_vpc.main.cidr_block}" ]
  }

  ingress {
    to_port = -1
    from_port = -1
    protocol = "icmp"
    cidr_blocks = [ "${aws_vpc.main.cidr_block}" ]
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "${aws_vpc.main.cidr_block}" ]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks =  [ "${var.whitelist}" ]
  }

  tags {
    Name = "bastion"
    Environment = "${var.environment}"
    Region = "${var.region}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "bastion" {
  name = "main-bastion-${var.environment}"
  image_id = "${data.aws_ami.debian.id}"
  instance_type = "t2.micro"
  security_groups = [ "${aws_security_group.bastion.id}" ]
  associate_public_ip_address = true
  key_name = "${aws_key_pair.bastion.key_name}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "bastion" {
  name = "main-bastion-${var.environment}"
  launch_configuration = "${aws_launch_configuration.bastion.name}"
  vpc_zone_identifier = [ "${aws_subnet.main.*.id}" ]
  min_size = 1
  max_size = 1
  desired_capacity = 1

  tag {
    key = "Name"
    value = "main-bastion"
    propagate_at_launch = true
  }

  tag {
    key = "Environment"
    value = "${var.environment}"
    propagate_at_launch = true
  }

  tag {
    key = "Region"
    value = "${var.region}"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
