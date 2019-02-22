resource "aws_vpc" "main" {
  cidr_block = "${lookup(var.vpc_cidrs, var.region)}"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags {
    Name = "main"
    Environment = "${var.environment}"
    Region = "${var.region}"
  }
}

resource "aws_subnet" "main" {
  count = "${length(data.aws_availability_zones.main.names)}"
  availability_zone = "${data.aws_availability_zones.main.names[count.index]}"
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)}"
  map_public_ip_on_launch = false

  tags {
    Name = "main-${count.index}"
    Environment = "${var.environment}"
    Region = "${var.region}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "main"
    Environment = "${var.environment}"
    Region = "${var.region}"
  }
}

resource "aws_route_table" "main" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }

  tags {
    Name = "main"
    Environment = "${var.environment}"
    Region = "${var.region}"
  }
}

resource "aws_route_table_association" "main" {
  count = "${length(data.aws_availability_zones.main.names)}"
  subnet_id = "${element(aws_subnet.main.*.id, count.index)}"
  route_table_id = "${aws_route_table.main.id}"
}
