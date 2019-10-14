# https://www.terraform.io/docs/configuration/variables.html

variable "domain" {
  type        = string
  description = "The domain name."
}

variable "cert_domain" {
  type        = string
  description = "Main domain or subdomain name for the certificate."
}

variable "cert_alt_domains" {
  type        = list(string)
  description = "Alternative domain or subdomain names for the certificate."
}

variable "tags" {
  type        = map(string)
  description = "Resource tags for the certificate."
}
