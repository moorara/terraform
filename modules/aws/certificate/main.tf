# https://www.terraform.io/docs/providers/aws/d/route53_zone.html
data "aws_route53_zone" "primary" {
  name = "${var.domain}."
}

# https://www.terraform.io/docs/providers/aws/r/acm_certificate.html
resource "aws_acm_certificate" "primary" {
  validation_method         = "DNS"
  domain_name               = var.cert_domain
  subject_alternative_names = var.cert_alt_domains

  tags = var.common_tags
}

# https://www.terraform.io/docs/providers/aws/r/route53_record.html
resource "aws_route53_record" "validation" {
  zone_id = "${data.aws_route53_zone.primary.id}"
  name    = "${aws_acm_certificate.primary.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.primary.domain_validation_options.0.resource_record_type}"
  records = [ "${aws_acm_certificate.primary.domain_validation_options.0.resource_record_value}" ]
  ttl     = 60
}

# https://www.terraform.io/docs/providers/aws/r/route53_record.html
resource "aws_route53_record" "alt_validation" {
  count = length(var.cert_alt_domains)

  zone_id = "${data.aws_route53_zone.primary.id}"
  name    = lookup("${aws_acm_certificate.primary.domain_validation_options[count.index + 1]}", "resource_record_name")
  type    = lookup("${aws_acm_certificate.primary.domain_validation_options[count.index + 1]}", "resource_record_type")
  records = [ "${lookup(aws_acm_certificate.primary.domain_validation_options[count.index + 1], "resource_record_value")}" ]
  ttl     = 60
}

# https://www.terraform.io/docs/providers/aws/r/acm_certificate_validation.html
resource "aws_acm_certificate_validation" "primary" {
  certificate_arn         = "${aws_acm_certificate.primary.arn}"
  validation_record_fqdns = concat(list("${aws_route53_record.validation.fqdn}"), "${aws_route53_record.alt_validation.*.fqdn}")
}
