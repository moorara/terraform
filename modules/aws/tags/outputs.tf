# https://www.terraform.io/docs/configuration/outputs.html

output "common" {
  description = "A map of common tags that every resource should have."
  value = {
    Environment = var.environment
    UUID        = var.uuid
    Owner       = var.owner
    GitURL      = var.git_url
    GitBranch   = var.git_branch
    GitCommit   = var.git_commit
  }
}

output "region" {
  description = "A map of regional tags for resources that are not global."
  value = {
    Region = var.region
  }
}
