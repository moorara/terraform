# https://www.terraform.io/docs/configuration/locals.html

locals {
  common_tags = {
    Environment = "${var.environment}"
    Owner       = "${var.owner}"
    GitCommit   = "${var.git_commit}"
    GitBranch   = "${var.git_branch}"
    GitRepo     = "${var.git_repo}"
  }
}
