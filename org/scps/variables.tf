variable "deny_root_account" {
  type        = bool
  default     = true
  description = "Attach an SCP that denies root account actions in member accounts"
}

variable "deny_leaving_org" {
  type        = bool
  default     = true
  description = "Attach an SCP that prevents accounts from leaving the organization"
}

variable "deny_public_s3" {
  type        = bool
  default     = true
  description = "Attach an SCP that denies S3 public access block removal"
}

variable "deny_unapproved_regions" {
  type        = bool
  default     = false
  description = "Attach an SCP that restricts API calls to approved regions"
}

variable "approved_regions" {
  type        = list(string)
  default     = ["us-east-1", "us-west-2"]
  description = "Allowed AWS regions when deny_unapproved_regions = true. IAM and global services are exempt"
}

variable "require_imdsv2" {
  type        = bool
  default     = true
  description = "Attach an SCP that requires IMDSv2 for EC2 instances"
}

variable "deny_cloudtrail_disable" {
  type        = bool
  default     = true
  description = "Attach an SCP that prevents CloudTrail from being disabled or modified"
}

variable "target_ou_ids" {
  type        = list(string)
  description = "List of OU IDs to attach SCPs to"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags applied to SCP resources"
}
