variable "aws_region" {
  description = "AWS region for log archive resources."
  type        = string
}

variable "log_archive_bucket_name" {
  description = "Globally unique centralized log archive bucket name."
  type        = string
}

variable "org_id" {
  description = "AWS Organization ID used to deny non-organization access. Leave empty until the organization ID is known."
  type        = string
  default     = ""
}

variable "delivery_source_account_ids" {
  description = "AWS account IDs allowed as service delivery source accounts."
  type        = list(string)
  default     = []
}

variable "allow_cloudtrail_delivery" {
  description = "Allow CloudTrail to deliver logs to the central log archive bucket."
  type        = bool
  default     = false
}

variable "allow_vpc_flow_logs_delivery" {
  description = "Allow VPC Flow Logs to deliver logs to the central log archive bucket."
  type        = bool
  default     = false
}

variable "allow_config_delivery" {
  description = "Allow AWS Config to deliver logs to the central log archive bucket."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags applied to all log archive environment resources."
  type        = map(string)
}
