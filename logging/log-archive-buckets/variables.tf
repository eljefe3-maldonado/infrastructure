variable "bucket_name" {
  description = "Globally unique log archive bucket name."
  type        = string
}

variable "kms_key_arn" {
  description = "KMS key ARN used to encrypt log objects."
  type        = string
}

variable "force_destroy" {
  description = "Whether to allow destroying a non-empty log archive bucket. Keep false for production."
  type        = bool
  default     = false
}

variable "transition_ia_days" {
  description = "Number of days after which objects transition to STANDARD_IA storage class."
  type        = number
  default     = 30
}

variable "transition_glacier_days" {
  description = "Number of days after which objects transition to GLACIER storage class."
  type        = number
  default     = 90
}

variable "expiration_days" {
  description = "Number of days before objects are permanently deleted. Default 2557 = 7 years."
  type        = number
  default     = 2557
}

variable "enable_expiration" {
  description = "Enable object expiration lifecycle rule."
  type        = bool
  default     = true
}

variable "allow_cloudtrail_delivery" {
  description = "Allow CloudTrail to deliver logs to this bucket."
  type        = bool
  default     = false
}

variable "allow_vpc_flow_logs_delivery" {
  description = "Allow VPC Flow Logs to deliver logs to this bucket."
  type        = bool
  default     = false
}

variable "allow_config_delivery" {
  description = "Allow AWS Config to deliver snapshots to this bucket."
  type        = bool
  default     = false
}

variable "allowed_account_ids" {
  description = "List of AWS account IDs allowed to write objects to this bucket (cross-account PutObject)."
  type        = list(string)
  default     = []
}

variable "delivery_source_account_ids" {
  description = "AWS account IDs allowed as service delivery source accounts for CloudTrail, VPC Flow Logs, and Config."
  type        = list(string)
  default     = []
}

variable "org_id" {
  description = "AWS Organization ID. When set, denies access from outside the organization."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags applied to log archive resources."
  type        = map(string)
  default     = {}
}
