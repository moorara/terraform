# https://www.terraform.io/docs/configuration/outputs.html

output "certificate_arn" {
  value = "${aws_acm_certificate_validation.primary.certificate_arn}"
}
