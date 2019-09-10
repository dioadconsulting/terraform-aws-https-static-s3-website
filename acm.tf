resource "aws_acm_certificate" "cert" {
  provider = "aws.us-east-1"

  domain_name       = var.domain_name
  validation_method = "DNS"

  subject_alternative_names = var.domain_aliases

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  provider = "aws.us-east-1"
  name     = "${aws_acm_certificate.cert.domain_validation_options[1 + count.index].resource_record_name}"
  type     = "${aws_acm_certificate.cert.domain_validation_options[1 + count.index].resource_record_type}"
  zone_id  = var.hosted_zone_id
  records  = ["${aws_acm_certificate.cert.domain_validation_options[1 + count.index].resource_record_value}"]
  ttl      = 60

  count = length(var.domain_aliases)
}


resource "aws_route53_record" "cert_validation_0" {
  provider = "aws.us-east-1"
  name     = "${aws_acm_certificate.cert.domain_validation_options[0].resource_record_name}"
  type     = "${aws_acm_certificate.cert.domain_validation_options[0].resource_record_type}"
  zone_id  = var.hosted_zone_id
  records  = ["${aws_acm_certificate.cert.domain_validation_options[0].resource_record_value}"]
  ttl      = 60

}

resource "aws_acm_certificate_validation" "cert" {
  provider = "aws.us-east-1"

  certificate_arn         = "${aws_acm_certificate.cert.arn}"
  validation_record_fqdns = concat([aws_route53_record.cert_validation_0.fqdn], aws_route53_record.cert_validation[*].fqdn)
}
