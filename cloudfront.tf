resource "aws_cloudfront_origin_access_control" "site" {
  name                              = var.domain_name
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

data "aws_cloudfront_cache_policy" "caching_optimized" {
  name = "Managed-CachingOptimized"
}

resource "aws_cloudfront_response_headers_policy" "security_headers" {
  name = replace(var.domain_name, ".", "-")

  security_headers_config {
    strict_transport_security {
      access_control_max_age_sec = 31536000
      include_subdomains         = true
      preload                    = true
      override                   = true
    }

    content_type_options {
      override = true
    }

    frame_options {
      frame_option = "DENY"
      override     = true
    }

    xss_protection {
      mode_block = true
      protection = true
      override   = true
    }

    referrer_policy {
      referrer_policy = "strict-origin-when-cross-origin"
      override        = true
    }
  }
}

resource "aws_cloudfront_distribution" "site" {
  provider = aws.us-east-1

  origin {
    domain_name              = aws_s3_bucket.site.bucket_regional_domain_name
    origin_id                = "S3-${aws_s3_bucket.site.id}"
    origin_access_control_id = aws_cloudfront_origin_access_control.site.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = tolist(local.dns_records)

  custom_error_response {
    error_code            = 400
    response_code         = 400
    response_page_path    = "/error/400.html"
    error_caching_min_ttl = 1800
  }
  custom_error_response {
    error_code            = 403
    response_code         = 403
    response_page_path    = "/error/403.html"
    error_caching_min_ttl = 1800
  }
  custom_error_response {
    error_code            = 404
    response_code         = 404
    response_page_path    = "/error/404.html"
    error_caching_min_ttl = 1800
  }
  custom_error_response {
    error_code            = 405
    response_code         = 405
    response_page_path    = "/error/405.html"
    error_caching_min_ttl = 1800
  }
  custom_error_response {
    error_code            = 414
    response_code         = 414
    response_page_path    = "/error/414.html"
    error_caching_min_ttl = 1800
  }
  custom_error_response {
    error_code            = 416
    response_code         = 416
    response_page_path    = "/error/416.html"
    error_caching_min_ttl = 1800
  }
  custom_error_response {
    error_code            = 500
    response_code         = 500
    response_page_path    = "/error/500.html"
    error_caching_min_ttl = 1800
  }
  custom_error_response {
    error_code            = 501
    response_code         = 501
    response_page_path    = "/error/501.html"
    error_caching_min_ttl = 1800
  }
  custom_error_response {
    error_code            = 502
    response_code         = 502
    response_page_path    = "/error/502.html"
    error_caching_min_ttl = 1800
  }
  custom_error_response {
    error_code            = 503
    response_code         = 503
    response_page_path    = "/error/503.html"
    error_caching_min_ttl = 1800
  }
  custom_error_response {
    error_code            = 504
    response_code         = 504
    response_page_path    = "/error/504.html"
    error_caching_min_ttl = 1800
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${aws_s3_bucket.site.id}"

    cache_policy_id            = data.aws_cloudfront_cache_policy.caching_optimized.id
    response_headers_policy_id = aws_cloudfront_response_headers_policy.security_headers.id

    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate_validation.cert.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}

