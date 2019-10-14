# https://www.terraform.io/docs/configuration/outputs.html

output "vpc_cidr" {
  value = module.infra.vpc_cidr
}

output "public_subnet_cidrs" {
  value = module.infra.public_subnet_cidrs
}

output "private_subnet_cidrs" {
  value = module.infra.private_subnet_cidrs
}

output "elastic_ips" {
  value = module.infra.elastic_ips
}
