variable "description" {
  description = "KMS key description."
  type        = string
}

variable "alias_name" {
  description = "KMS alias name without the alias/ prefix."
  type        = string
}

variable "deletion_window_in_days" {
  description = "KMS key deletion window in days."
  type        = number
  default     = 30
}

variable "enable_key_rotation" {
  description = "Enable automatic annual key rotation."
  type        = bool
  default     = true
}

variable "allowed_service_principals" {
  description = "List of AWS service principal identifiers (e.g. cloudtrail.amazonaws.com) allowed to use the key."
  type        = list(string)
  default     = []
}

variable "allowed_iam_principals" {
  description = "List of IAM principal ARNs allowed to use the key for encrypt/decrypt operations."
  type        = list(string)
  default     = []
}

variable "allow_grants" {
  description = "Allow kms:CreateGrant for AWS service integrations such as EBS/ECS."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags applied to KMS resources."
  type        = map(string)
  default     = {}
}
