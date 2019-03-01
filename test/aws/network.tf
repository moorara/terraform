# https://www.terraform.io/docs/providers/aws/r/vpc.html
resource "aws_vpc" "primary" {
  cidr_block           = "${lookup(var.vpc_cidrs, var.region)}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = "${merge(
    local.common_tags,
    map(
      "Name",   "${var.name}",
      "Region", "${var.region}"
    )
  )}"
}

# https://www.terraform.io/docs/providers/aws/r/subnet.html
resource "aws_subnet" "primary" {
  count                   = "${length(data.aws_availability_zones.available.names)}"
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  vpc_id                  = "${aws_vpc.primary.id}"
  cidr_block              = "${cidrsubnet(aws_vpc.primary.cidr_block, 8, count.index)}"
  map_public_ip_on_launch = false

  tags = "${merge(
    local.common_tags,
    map(
      "Name",   "${var.name}-${count.index}",
      "Region", "${var.region}"
    )
  )}"
}

# https://www.terraform.io/docs/providers/aws/r/internet_gateway.html
resource "aws_internet_gateway" "primary" {
  vpc_id = "${aws_vpc.primary.id}"

  tags = "${merge(
    local.common_tags,
    map(
      "Name",   "${var.name}",
      "Region", "${var.region}"
    )
  )}"
}

# https://www.terraform.io/docs/providers/aws/r/route.html
resource "aws_route" "internet" {
  route_table_id         = "${aws_vpc.primary.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.primary.id}"
}

# https://www.terraform.io/docs/providers/aws/r/route_table.html
resource "aws_route_table" "internet" {
  vpc_id = "${aws_vpc.primary.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.primary.id}"
  }

  tags = "${merge(
    local.common_tags,
    map(
      "Name",   "${var.name}-internet",
      "Region", "${var.region}"
    )
  )}"
}

# https://www.terraform.io/docs/providers/aws/r/route_table_association.html
resource "aws_route_table_association" "internet" {
  count          = "${length(data.aws_availability_zones.available.names)}"
  subnet_id      = "${element(aws_subnet.primary.*.id, count.index)}"
  route_table_id = "${aws_route_table.internet.id}"
}

# https://www.terraform.io/docs/providers/aws/r/main_route_table_assoc.html
/* resource "aws_main_route_table_association" "internet" {
  vpc_id         = "${aws_vpc.primary.id}"
  route_table_id = "${aws_route_table.internet.id}"
} */

# https://www.terraform.io/docs/providers/aws/r/flow_log.html
resource "aws_flow_log" "vpc" {
  iam_role_arn         = "${aws_iam_role.vpc.arn}"
  log_destination      = "${aws_cloudwatch_log_group.vpc.arn}"
  log_destination_type = "cloud-watch-logs"
  traffic_type         = "ALL"
  vpc_id               = "${aws_vpc.primary.id}"
}

# https://www.terraform.io/docs/providers/aws/r/cloudwatch_log_group.html
resource "aws_cloudwatch_log_group" "vpc" {
  name              = "${var.name}-${var.environment}-vpc"
  retention_in_days = 30

  tags = "${merge(
    local.common_tags,
    map(
      "Name",   "${var.name}-vpc",
      "Region", "${var.region}"
    )
  )}"
}

# https://www.terraform.io/docs/providers/aws/r/iam_role.html
resource "aws_iam_role" "vpc" {
  name = "${var.name}-${var.environment}-vpc"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.name}-vpc",
    )
  )}"
}

# https://www.terraform.io/docs/providers/aws/r/iam_role_policy.html
resource "aws_iam_role_policy" "vpc" {
  name = "${var.name}-${var.environment}-vpc"
  role = "${aws_iam_role.vpc.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "${aws_cloudwatch_log_group.vpc.arn}"
    }
  ]
}
EOF
}
