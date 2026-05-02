variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "org_trail_name" {
  type        = string
  default     = "org-trail"
  description = "Organization CloudTrail name"
}

variable "log_archive_bucket_name" {
  type        = string
  description = "Centralized log archive S3 bucket name"
}

variable "log_archive_kms_key_arn" {
  type        = string
  description = "KMS key ARN for CloudTrail encryption (from log-archive environment output)"
}

variable "enable_guardduty" {
  type        = bool
  default     = true
  description = "Enable GuardDuty"
}

variable "guardduty_delegated_admin_account_id" {
  type        = string
  default     = ""
  description = "GuardDuty delegated admin account ID. Leave empty if this IS the security account"
}

variable "enable_security_hub" {
  type        = bool
  default     = true
  description = "Enable Security Hub"
}

variable "security_hub_delegated_admin_account_id" {
  type        = string
  default     = ""
  description = "Security Hub delegated admin account ID"
}

variable "access_analyzer_type" {
  type        = string
  default     = "ORGANIZATION"
  description = "ACCOUNT or ORGANIZATION"
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to all security environment resources"
}
