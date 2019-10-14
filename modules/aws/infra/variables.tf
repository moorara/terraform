# https://www.terraform.io/docs/configuration/variables.html
# https://www.terraform.io/docs/configuration/types.html

# https://en.wikipedia.org/wiki/Classful_network
variable "vpc_cidrs" {
  type        = map(string)
  description = "VPC CIDR for each AWS Region."
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

variable "trusted_cidrs" {
  type        = list(string)
  description = "A list of trusted CIDR blocks for incoming traffic."
  default     = [ "0.0.0.0/0" ]
}

variable "enable_vpc_logs" {
  type        = bool
  description = "Whether or not to enable VPC flow logs."
  default     = false
}

variable "az_count" {
  type        = number
  description = "The total number of availability zones required."
  default     = 99  // This is a hack to default to all availability zones
}

variable "bastion_public_key" {
  type        = string
  description = "The path to the public key for bastion hosts."
}

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

variable "common_tags" {
  type        = map(string)
  description = "A map of common tags for all resources."
}

variable "region_tag" {
  type        = map(string)
  description = "A map of regional tags for non-global resources."
}
