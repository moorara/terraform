# https://www.terraform.io/docs/configuration/variables.html

variable "access_key" {
  type        = string
  description = "AWS Access Key ID"
}

variable "secret_key" {
  type        = string
  description = "AWS Secret Access Key"
}

variable "region" {
  type        = string
  description = "AWS region to deploy"
  default     = "us-east-1"
}

variable "name" {
  type        = string
  description = "Deployment name"
}

variable "environment" {
  type        = string
  description = "Environment name for the deployment"
  default     = "test"
}

variable "owner" {
  type        = string
  description = "The name, username, or ID of user who owns the deployment"
}

variable "git_commit" {
  type        = string
  description = "Git commit hash (short or long)"
}

variable "git_branch" {
  type        = string
  description = "Git branch name"
}

variable "git_repo" {
  type        = string
  description = "Git repository remote url"
}

variable "whitelist" {
  type        = list(string)
  description = "The allowed list of IP addresses and CIDRs for incoming traffic"
  default     = [ "0.0.0.0/0" ]
}

variable "vpc_cidrs" {
  type        = map(string)
  description = "VPC CIDR per region"
  default = {
    ap-northeast-1 = "10.10.0.0/16",
    ap-northeast-2 = "10.11.0.0/16",
    ap-south-1     = "10.12.0.0/16",
    ap-southeast-1 = "10.13.0.0/16",
    ap-southeast-2 = "10.14.0.0/16",
    ca-central-1   = "10.15.0.0/16",
    eu-central-1   = "10.16.0.0/16",
    eu-north-1     = "10.17.0.0/16",
    eu-west-1      = "10.18.0.0/16",
    eu-west-2      = "10.19.0.0/16",
    eu-west-3      = "10.20.0.0/16",
    sa-east-1      = "10.21.0.0/16",
    us-east-1      = "10.22.0.0/16",
    us-east-2      = "10.23.0.0/16",
    us-west-1      = "10.24.0.0/16",
    us-west-2      = "10.25.0.0/16"
  }
}
