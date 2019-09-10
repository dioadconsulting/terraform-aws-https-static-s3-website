resource "aws_s3_bucket" "site" {
  bucket = var.bucket_name != "" ? var.bucket_name : var.domain_name
  acl    = "authenticated-read"

  versioning {
    enabled = true
  }

  website {
    index_document = "index.html"
    #    error_document = "error.html"
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = setunion([var.domain_name], var.domain_aliases)
  }
}

data "aws_iam_policy_document" "site_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.site.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = ["${aws_s3_bucket.site.arn}"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
    }
  }
}

resource "aws_s3_bucket_policy" "site" {
  bucket = "${aws_s3_bucket.site.id}"
  policy = "${data.aws_iam_policy_document.site_policy.json}"
}

resource "aws_s3_bucket_public_access_block" "site" {
  bucket = "${aws_s3_bucket.site.id}"

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true

}