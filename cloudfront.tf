resource "random_string" "origin_id" {
  keepers = {
    # Generate a new id each time we switch to a new AMI id
    bucket_arn = aws_s3_bucket.site.arn
  }

  length = 12
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  provider = "aws.us-east-1"
  comment  = "Cloudfront S3 Access Identify for ${var.domain_name}"
}


resource "aws_cloudfront_distribution" "site" {
  provider = "aws.us-east-1"

  origin {
    domain_name = "${aws_s3_bucket.site.bucket_regional_domain_name}"
    origin_id   = "${random_string.origin_id.result}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = local.dns_records

  custom_error_response {
    error_code            = "400"
    response_code         = "400"
    response_page_path    = "/error/400.html"
    error_caching_min_ttl = "1800"
  }
  custom_error_response {
    error_code            = "403"
    response_code         = "403"
    response_page_path    = "/error/403.html"
    error_caching_min_ttl = "1800"
  }
  custom_error_response {
    error_code            = "404"
    response_code         = "404"
    response_page_path    = "/error/404.html"
    error_caching_min_ttl = "1800"
  }
  custom_error_response {
    error_code            = "405"
    response_code         = "405"
    response_page_path    = "/error/405.html"
    error_caching_min_ttl = "1800"
  }
  custom_error_response {
    error_code            = "414"
    response_code         = "414"
    response_page_path    = "/error/414.html"
    error_caching_min_ttl = "1800"
  }
  custom_error_response {
    error_code            = "416"
    response_code         = "416"
    response_page_path    = "/error/416.html"
    error_caching_min_ttl = "1800"
  }
  custom_error_response {
    error_code            = "500"
    response_code         = "500"
    response_page_path    = "/error/500.html"
    error_caching_min_ttl = "1800"
  }
  custom_error_response {
    error_code            = "501"
    response_code         = "501"
    response_page_path    = "/error/501.html"
    error_caching_min_ttl = "1800"
  }
  custom_error_response {
    error_code            = "502"
    response_code         = "502"
    response_page_path    = "/error/502.html"
    error_caching_min_ttl = "1800"
  }
  custom_error_response {
    error_code            = "503"
    response_code         = "503"
    response_page_path    = "/error/503.html"
    error_caching_min_ttl = "1800"
  }
  custom_error_response {
    error_code            = "504"
    response_code         = "504"
    response_page_path    = "/error/504.html"
    error_caching_min_ttl = "1800"
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${random_string.origin_id.result}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    lambda_function_association {
      event_type   = "origin-response"
      lambda_arn   = "${module.strict_headers.lambda_qualified_arn}"
      include_body = false
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 7200
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate_validation.cert.certificate_arn
    ssl_support_method  = "sni-only"
  }

}