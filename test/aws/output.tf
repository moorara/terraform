output "vpc_cidr" {
  value = "${aws_vpc.main.cidr_block}"
}

output "subnet_cidrs" {
  value = [ "${aws_subnet.main.*.cidr_block}" ]
}

output "subnet_zones" {
  value = [ "${join(", ", aws_subnet.main.*.availability_zone)}" ]
}
