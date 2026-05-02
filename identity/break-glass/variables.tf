variable "role_name" {
  type        = string
  default     = "break-glass"
  description = "Break-glass IAM role name"
}

variable "principal_arns" {
  type        = list(string)
  description = "List of IAM principal ARNs (users or roles) allowed to assume the break-glass role"

  validation {
    condition     = length(var.principal_arns) > 0
    error_message = "At least one trusted principal ARN is required for the break-glass role."
  }
}

variable "require_mfa" {
  type        = bool
  default     = true
  description = "Require MFA to assume the break-glass role"
}

variable "mfa_age_seconds" {
  type        = number
  default     = 3600
  description = "Maximum age of MFA authentication in seconds. Default 3600 (1 hour)"

  validation {
    condition     = var.mfa_age_seconds > 0 && var.mfa_age_seconds <= 3600
    error_message = "mfa_age_seconds must be between 1 and 3600."
  }
}

variable "max_session_duration" {
  type        = number
  default     = 3600
  description = "Maximum session duration for the role in seconds. Between 3600 and 43200"

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration must be between 3600 and 43200 seconds."
  }
}

variable "permission_boundary_arn" {
  type        = string
  default     = ""
  description = "Optional permission boundary ARN to attach to the break-glass role"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags applied to break-glass resources"
}
