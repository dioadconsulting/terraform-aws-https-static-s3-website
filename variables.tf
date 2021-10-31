variable "domain_name" {}

variable "domain_aliases" {
  type = list(any)
}

variable "bucket_name" {
  default = ""
}

variable "hosted_zone_id" {}
