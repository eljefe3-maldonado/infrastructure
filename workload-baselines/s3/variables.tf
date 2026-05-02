variable "bucket_name" {
  type        = string
  description = "Globally unique S3 bucket name"
}

variable "kms_key_arn" {
  type        = string
  default     = ""
  description = "KMS key ARN for SSE-KMS encryption. Leave empty to use SSE-S3 (AES256)"
}

variable "enable_versioning" {
  type        = bool
  default     = true
  description = "Enable S3 versioning"
}

variable "force_destroy" {
  type        = bool
  default     = false
  description = "Allow destroying non-empty bucket. Keep false for production"
}

variable "enable_lifecycle" {
  type        = bool
  default     = false
  description = "Enable lifecycle rules for cost optimization"
}

variable "noncurrent_version_expiration_days" {
  type        = number
  default     = 90
  description = "Days before noncurrent object versions are deleted. Only used when enable_lifecycle = true"
}

variable "intelligent_tiering" {
  type        = bool
  default     = false
  description = "Enable Intelligent-Tiering for automatic cost optimization"
}

variable "cors_rules" {
  type = list(object({
    allowed_headers = optional(list(string), [])
    allowed_methods = list(string)
    allowed_origins = list(string)
    expose_headers  = optional(list(string), [])
    max_age_seconds = optional(number, 0)
  }))
  default     = []
  description = "CORS rules for browser-based access"
}

variable "allowed_account_ids" {
  type        = list(string)
  default     = []
  description = "Additional AWS account IDs allowed cross-account access"
}

variable "bucket_policy_statements" {
  type        = list(any)
  default     = []
  description = "Additional IAM policy statements to merge into the bucket policy"
}

variable "enable_server_access_logging" {
  type        = bool
  default     = false
  description = "Enable S3 server access logging"
}

variable "access_log_bucket" {
  type        = string
  default     = ""
  description = "Target bucket for server access logs. Required when enable_server_access_logging = true"
}

variable "access_log_prefix" {
  type        = string
  default     = ""
  description = "Prefix for server access logs"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags applied to bucket resources"
}
