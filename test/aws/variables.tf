# https://www.terraform.io/docs/configuration/variables.html

variable "access_key" {
  type = "string"
}

variable "secret_key" {
  type = "string"
}

variable "region" {
  type    = "string"
  default = "us-east-1"
}

variable "name" {
  type    = "string"
  default = "pilot"
}

variable "environment" {
  type    = "string"
  default = "test"
}

variable "whitelist" {
  type    = "list"
  default = [ "0.0.0.0/0" ]
}

variable "git_commit" {
  type = "string"
}

variable "git_branch" {
  type = "string"
}

variable "git_repo" {
  type = "string"
}
