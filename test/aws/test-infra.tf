# Terraform test files should be self-contained and contain all variables, locals, outputs, data, and resources.

variable "bastion_key_name" {
  type = string
}

module "infra" {
  source = "../../modules/aws/infra"

  az_count           = 3
  name               = var.name
  environment        = var.environment
  region             = var.region
  common_tags        = module.tags.common
  region_tag         = module.tags.region
  bastion_public_key = "${path.module}/${var.bastion_key_name}.pub"
}
