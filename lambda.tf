module strict_headers {
  source = "../aws-cloudfront-https-strict-headers-lambda"

  suffix = "${var.domain_name}"

  providers = {
    aws = "aws.us-east-1"
  }
}