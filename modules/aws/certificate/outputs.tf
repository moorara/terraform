# https://www.terraform.io/docs/configuration/outputs.html

output "certificate_arn" {
  value       = aws_acm_certificate.main.arn
  description = "The ARN of the certificate."
}
