# ================================================================================
#  VPC
# ================================================================================

# https://www.terraform.io/docs/providers/aws/r/vpc.html
resource "aws_vpc" "main" {
  cidr_block = lookup(var.vpc_cidrs, var.region)

  tags = merge(var.common_tags, var.region_tag, map(
    "Name", local.name,
  ))
}

# ================================================================================
#  Subnets
# ================================================================================

# https://www.terraform.io/docs/providers/aws/r/subnet.html
resource "aws_subnet" "public" {
  count = local.az_len

  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(var.common_tags, var.region_tag, map(
    "Name", format("%s-public-%d", local.name, 1 + count.index),
  ))
}

# https://www.terraform.io/docs/providers/aws/r/subnet.html
resource "aws_subnet" "private" {
  count = local.az_len

  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, 100 + count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(var.common_tags, var.region_tag, map(
    "Name", format("%s-private-%d", local.name, 1 + count.index),
  ))
}

# ================================================================================
#  Elastic IP Addresses
# ================================================================================

# https://www.terraform.io/docs/providers/aws/r/eip.html
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html
resource "aws_eip" "nat" {
  count = local.az_len

  vpc = true

  tags = merge(var.common_tags, var.region_tag, map(
    "Name", format("%s-%d", local.name, 1 + count.index),
  ))
}

# ================================================================================
#  Gateways
# ================================================================================

# https://www.terraform.io/docs/providers/aws/r/internet_gateway.html
# https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.common_tags, var.region_tag, map(
    "Name", local.name,
  ))
}

# https://www.terraform.io/docs/providers/aws/r/nat_gateway.html
# https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat.html
# https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html
resource "aws_nat_gateway" "main" {
  count = local.az_len

  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)

  tags = merge(var.common_tags, var.region_tag, map(
    "Name", format("%s-%d", local.name, 1 + count.index),
  ))
}

# ================================================================================
#  Route Tables
# ================================================================================

# https://www.terraform.io/docs/providers/aws/r/route_table.html
# https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(var.common_tags, var.region_tag, map(
    "Name", format("%s-public", local.name),
  ))
}

# https://www.terraform.io/docs/providers/aws/r/route_table_association.html
resource "aws_route_table_association" "public" {
  count = local.az_len

  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

# https://www.terraform.io/docs/providers/aws/r/route_table.html
# https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html
resource "aws_route_table" "private" {
  count = local.az_len

  vpc_id = aws_vpc.main.id

  tags = merge(var.common_tags, var.region_tag, map(
    "Name", format("%s-private-%d", local.name, 1 + count.index),
  ))
}

# https://www.terraform.io/docs/providers/aws/r/route_table_association.html
resource "aws_route_table_association" "private" {
  count = local.az_len

  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}
