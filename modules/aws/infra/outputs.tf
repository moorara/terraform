# https://www.terraform.io/docs/configuration/outputs.html

output "vpc_cidr" {
  value       = aws_vpc.main.cidr_block
  description = "The CIDR block of the VPC."
}

output "public_subnet_cidrs" {
  value       = zipmap(aws_subnet.public.*.availability_zone, aws_subnet.public.*.cidr_block)
  description = "A map of availability zones to CIDR blocks for the public subnets."
}

output "private_subnet_cidrs" {
  value       = zipmap(aws_subnet.private.*.availability_zone, aws_subnet.private.*.cidr_block)
  description = "A map of availability zones to CIDR blocks for the private subnets."
}

output "elastic_ips" {
  value       = aws_eip.nat.*.public_ip
  description = "A list of elastic public IP addresses."
}

output "bastion_key_name" {
  value       = aws_key_pair.bastion.key_name
  description = "The key pair name for bastion hosts."
}
