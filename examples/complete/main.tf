provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

module "website" {
  source = "../../"

  domain_name    = "example.com"
  domain_aliases = ["www.example.com"]
  hosted_zone_id = "Z1234567890ABC"

  providers = {
    aws           = aws
    aws.us-east-1 = aws.us-east-1
  }
}
