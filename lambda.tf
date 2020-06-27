module strict_headers {
  source = git::https://github.com/dioadconsulting/terraform-aws-cloudfront-https-strict-headers-lambda?ref=0.1.1

  suffix = var.domain_name

  providers = {
    aws = aws.us-east-1
  }
}
