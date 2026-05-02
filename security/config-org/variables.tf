variable "config_recorder_name" {
  description = "AWS Config recorder name."
  type        = string
  default     = "default"
}

variable "delivery_channel_name" {
  description = "AWS Config delivery channel name."
  type        = string
  default     = "default"
}

variable "s3_bucket_name" {
  description = "S3 bucket for Config snapshots."
  type        = string
}

variable "s3_key_prefix" {
  description = "Optional S3 key prefix."
  type        = string
  default     = ""
}

variable "kms_key_arn" {
  description = "Optional KMS key ARN for Config encryption."
  type        = string
  default     = ""
}

variable "sns_topic_arn" {
  description = "Optional SNS topic ARN for Config notifications."
  type        = string
  default     = ""
}

variable "delivery_frequency" {
  description = "Config snapshot delivery frequency."
  type        = string
  default     = "TwentyFour_Hours"
}

variable "include_global_resource_types" {
  description = "Include global IAM resources in recording."
  type        = bool
  default     = true
}

variable "create_iam_role" {
  description = "Create the IAM role for AWS Config."
  type        = bool
  default     = true
}

variable "iam_role_arn" {
  description = "Existing IAM role ARN for Config. Used when create_iam_role = false."
  type        = string
  default     = ""
}

variable "delegated_admin_account_id" {
  description = "Account ID to delegate Config admin. Leave empty to skip."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags applied to Config resources."
  type        = map(string)
  default     = {}
}
