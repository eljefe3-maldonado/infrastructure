variable "trail_name" {
  description = "Organization CloudTrail name."
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 bucket for CloudTrail logs. Must already exist with CloudTrail delivery permissions."
  type        = string
}

variable "s3_key_prefix" {
  description = "Optional S3 key prefix for CloudTrail logs."
  type        = string
  default     = ""
}

variable "kms_key_arn" {
  description = "KMS key ARN for CloudTrail log encryption."
  type        = string
}

variable "cloudwatch_log_group_arn" {
  description = "CloudWatch Logs group ARN. Leave empty to skip CW Logs delivery."
  type        = string
  default     = ""
}

variable "cloudwatch_role_arn" {
  description = "IAM role ARN for CloudTrail to write to CloudWatch Logs. Required when cloudwatch_log_group_arn is set."
  type        = string
  default     = ""
}

variable "enable_log_file_validation" {
  description = "Enable log file integrity validation."
  type        = bool
  default     = true
}

variable "include_global_service_events" {
  description = "Include global service events (IAM, STS, etc.)."
  type        = bool
  default     = true
}

variable "is_multi_region_trail" {
  description = "Deploy as a multi-region trail."
  type        = bool
  default     = true
}

variable "is_organization_trail" {
  description = "Enable organization-level trail."
  type        = bool
  default     = true
}

variable "enable_management_events" {
  description = "Record management events."
  type        = bool
  default     = true
}

variable "management_event_read_write_type" {
  description = "ReadWriteType for management events: ReadOnly, WriteOnly, or All."
  type        = string
  default     = "All"
}

variable "data_resource_types" {
  description = "Optional list of data resource types: e.g. [\"AWS::S3::Object\", \"AWS::Lambda::Function\"]."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags applied to trail resources."
  type        = map(string)
  default     = {}
}
