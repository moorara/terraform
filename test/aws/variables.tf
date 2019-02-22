variable "access_key" {
  type = "string"
}

variable "secret_key" {
  type = "string"
}

variable "region" {
  type = "string"
  default = "us-east-1"
}

variable "environment" {
  type = "string"
  default = "test"
}

variable "whitelist" {
  type = "list"
  default = [ "0.0.0.0/0" ]
}
