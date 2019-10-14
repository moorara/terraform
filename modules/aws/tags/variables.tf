# https://www.terraform.io/docs/configuration/variables.html
# https://www.terraform.io/docs/configuration/types.html

variable "name" {
  type        = string
  description = "A name for the deployment."
}

variable "environment" {
  type        = string
  description = "The Environment name for deployment."
}

variable "region" {
  type        = string
  description = "The AWS Region for deployment."
}

variable "uuid" {
  type        = string
  description = "A unique identifier for the deployment."
}

variable "owner" {
  type        = string
  description = "An identifiable name, username, or ID that owns the deployment."
}

variable "git_url" {
  type        = string
  description = "The URL for the git repository."
}

variable "git_branch" {
  type        = string
  description = "The name of the git branch."
}

variable "git_commit" {
  type        = string
  description = "The short or long hash of the git commit."
}
