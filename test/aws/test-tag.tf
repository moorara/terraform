# Terraform test files should be self-contained and contain all variables, locals, outputs, data, and resources.

variable "uuid" {
  type = string
}

variable "owner" {
  type = string
}

variable "git_url" {
  type    = string
  default = "https://github.com/moorara/terraform/tree/main/test/aws"
}

variable "git_branch" {
  type = string
}

variable "git_commit" {
  type = string
}

module "tags" {
  source = "../../modules/aws/tags"

  name        = var.name
  environment = var.environment
  region      = var.region
  uuid        = var.uuid
  owner       = var.owner
  git_url     = var.git_url
  git_branch  = var.git_branch
  git_commit  = var.git_commit
}
