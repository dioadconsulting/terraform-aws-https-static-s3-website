

resource "aws_route53_record" "caa_aws" {
  zone_id = var.hosted_zone_id
  name    = var.domain_name
  type    = "CAA"
  ttl     = 300

  records = [
    "0 issue \"amazon.com\"",
  ]
}

resource "aws_route53_record" "caa_letsencrypt" {
  count = var.create_caa_letsencrypt_record ? 1 : 0

  zone_id = var.hosted_zone_id
  name    = var.domain_name
  type    = "CAA"
  ttl     = 300

  records = [
    "0 issue \"letsencrypt.org\"",
  ]
}

resource "aws_route53_record" "record_a" {
  zone_id = var.hosted_zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.site.domain_name
    zone_id                = aws_cloudfront_distribution.site.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "record_aaaa" {
  zone_id = var.hosted_zone_id
  name    = var.domain_name
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.site.domain_name
    zone_id                = aws_cloudfront_distribution.site.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "aliases_a" {
  for_each = toset(var.domain_aliases)

  zone_id = var.hosted_zone_id
  name    = each.value
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.site.domain_name
    zone_id                = aws_cloudfront_distribution.site.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "aliases_aaaa" {
  for_each = toset(var.domain_aliases)

  zone_id = var.hosted_zone_id
  name    = each.value
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.site.domain_name
    zone_id                = aws_cloudfront_distribution.site.hosted_zone_id
    evaluate_target_health = false
  }
}
