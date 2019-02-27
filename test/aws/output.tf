# https://www.terraform.io/docs/configuration/outputs.html

output "vpc_cidr" {
  value = "${aws_vpc.primary.cidr_block}"
}

output "subnet_cidrs" {
  value = [ "${aws_subnet.primary.*.cidr_block}" ]
}

output "subnet_zones" {
  value = [ "${join(", ", aws_subnet.primary.*.availability_zone)}" ]
}
