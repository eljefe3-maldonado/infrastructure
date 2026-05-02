variable "vpc_id" {
  type        = string
  description = "VPC ID to enable flow logs for"
}

variable "vpc_name" {
  type        = string
  description = "VPC name used in resource naming"
}

variable "destination_type" {
  type        = string
  default     = "s3"
  description = "Flow logs destination type: s3 or cloud-watch-logs"
}

variable "s3_bucket_arn" {
  type        = string
  default     = ""
  description = "S3 bucket ARN for flow logs. Required when destination_type = s3"
}

variable "s3_key_prefix" {
  type        = string
  default     = ""
  description = "S3 key prefix for flow logs"
}

variable "log_group_arn" {
  type        = string
  default     = ""
  description = "CloudWatch Logs group ARN. Required when destination_type = cloud-watch-logs"
}

variable "iam_role_arn" {
  type        = string
  default     = ""
  description = "IAM role ARN for CloudWatch delivery. Required when destination_type = cloud-watch-logs"
}

variable "traffic_type" {
  type        = string
  default     = "ALL"
  description = "ACCEPT, REJECT, or ALL"
}

variable "log_format" {
  type        = string
  default     = ""
  description = "Custom flow log format. Leave empty for the default AWS format"
}

variable "aggregation_interval" {
  type        = number
  default     = 600
  description = "Maximum aggregation interval in seconds: 60 or 600"
}

variable "file_format" {
  type        = string
  default     = "plain-text"
  description = "plain-text or parquet. Parquet is more efficient for Athena queries"
}

variable "hive_compatible_partitions" {
  type        = bool
  default     = false
  description = "Use Hive-compatible S3 partitions when destination_type = s3"
}

variable "per_hour_partition" {
  type        = bool
  default     = false
  description = "Partition logs by hour when destination_type = s3"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags applied to flow log resources"
}
