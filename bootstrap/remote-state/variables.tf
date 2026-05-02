variable "aws_region" {
  description = "AWS region where the remote state resources are created."
  type        = string
}

variable "state_bucket_name" {
  description = "Globally unique S3 bucket name for Terraform state."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.state_bucket_name))
    error_message = "The state bucket name must be a valid S3 bucket name."
  }
}

variable "lock_table_name" {
  description = "DynamoDB table name for Terraform state locking."
  type        = string
}

variable "kms_key_alias" {
  description = "Alias for the Terraform state KMS key, without the alias/ prefix."
  type        = string
  default     = "terraform-remote-state"
}

variable "force_destroy" {
  description = "Whether to allow destroying a non-empty state bucket. Keep false for production."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags applied to all bootstrap resources."
  type        = map(string)
  default     = {}
}
