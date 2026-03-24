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

variable "cloudfront_price_class" {
  type        = string
  description = "CloudFront distribution price class. Controls which edge locations serve the content."
  default     = "PriceClass_100"

  validation {
    condition     = contains(["PriceClass_100", "PriceClass_200", "PriceClass_All"], var.cloudfront_price_class)
    error_message = "cloudfront_price_class must be one of PriceClass_100, PriceClass_200, or PriceClass_All."
  }
}

variable "default_root_object" {
  type        = string
  description = "Object CloudFront returns when the root URL is requested."
  default     = "index.html"
}

variable "spa_mode" {
  type        = bool
  description = "When true, rewrites 403 and 404 responses to 200/index.html (single-page application pattern)."
  default     = false
}

variable "content_security_policy" {
  type        = string
  description = "Value for the Content-Security-Policy response header. Set to null to omit the header."
  default     = "default-src 'self'; img-src 'self' data:; style-src 'self' 'unsafe-inline'; script-src 'self'"
}

variable "permissions_policy" {
  type        = string
  description = "Value for the Permissions-Policy response header. Set to null to omit the header."
  default     = "camera=(), geolocation=(), microphone=(), payment=()"
}

variable "create_caa_letsencrypt_record" {
  type        = bool
  description = "When true, creates a CAA record permitting Let's Encrypt to issue certificates for the domain."
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Map of tags applied to all taggable resources."
  default     = {}
}

