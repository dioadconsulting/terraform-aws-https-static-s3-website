module "strict_headers" {
  source = "git::https://github.com/dioadconsulting/terraform-aws-cloudfront-https-strict-headers-lambda?ref=0.2.0"

  suffix = var.domain_name

  providers = {
    aws = aws.us-east-1
  }
}
