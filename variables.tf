variable "domain_name" {
  type        = string
  description = "Primary domain name for the website (e.g. example.com)."

  validation {
    condition     = length(var.domain_name) > 0
    error_message = "domain_name must not be empty."
  }
}

variable "domain_aliases" {
  type        = list(string)
  description = "Additional domain aliases (e.g. ['www.example.com']). May be empty."
  default     = []
}

variable "bucket_name" {
  type        = string
  description = "Override the S3 bucket name. Defaults to domain_name when null."
  default     = null
}

variable "hosted_zone_id" {
  type        = string
  description = "Route 53 hosted zone ID in which DNS records will be created."
}

variable "s3_lifecycle_noncurrent_version_expiration" {
  type        = number
  description = "Number of days after which noncurrent object versions are expired."
  default     = 30
}

variable "s3_abort_incomplete_multipart_upload_days" {
  type        = number
  description = "Number of days after which incomplete multipart uploads are aborted."
  default     = 2
}
