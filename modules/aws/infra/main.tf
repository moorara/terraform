# https://www.terraform.io/docs/providers/aws/d/availability_zones.html
data "aws_availability_zones" "available" {
  state = "available"
}
