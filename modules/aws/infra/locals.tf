# https://www.terraform.io/docs/configuration/locals.html

locals {
  name = "${var.name}-${var.environment}"

  # Total number of availability zones required
  az_len = min(
    var.az_count,
    length(data.aws_availability_zones.available.names)
  )
}
