variable "domain_name" {}

variable "domain_aliases" {
  type = list(any)
}

variable "bucket_name" {
  default = ""
}

variable "hosted_zone_id" {}

variable "s3_lifecycle_noncurrent_version_expiration" {
  default = 30
}

variable "s3_abort_incomplete_multipart_upload_days" {
  default = 2
}
