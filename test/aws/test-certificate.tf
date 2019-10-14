# Terraform test files should be self-contained and contain all variables, locals, outputs, data, and resources.

variable "domain" {
  type = string
}

locals {
  env_domain = "${var.environment}.${var.domain}"
  domain     = "${var.environment == "prod" ? var.domain : local.env_domain}"
}

module "certificate" {
  source = "../../modules/aws/certificate"

  domain           = var.domain
  cert_domain      = local.domain
  cert_alt_domains = [ "api.${local.domain}", "dev.${local.domain}" ]

  tags = merge(module.tags.common, module.tags.region, {
    "Name" = var.name
  })
}
