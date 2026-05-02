variable "enable" {
  description = "Enable Security Hub."
  type        = bool
  default     = true
}

variable "auto_enable_controls" {
  description = "Auto-enable Security Hub controls."
  type        = bool
  default     = true
}

variable "control_finding_generator" {
  description = "Finding generator mode: SECURITY_CONTROL or STANDARD_CONTROL."
  type        = string
  default     = "SECURITY_CONTROL"
}

variable "delegated_admin_account_id" {
  description = "Security account ID to delegate admin. Leave empty to skip."
  type        = string
  default     = ""
}

variable "auto_enable_org_members" {
  description = "How to auto-enroll org members: DEFAULT or NONE."
  type        = string
  default     = "DEFAULT"
}

variable "enable_cis_standard" {
  description = "Enable CIS AWS Foundations Benchmark standard."
  type        = bool
  default     = true
}

variable "enable_fsbp_standard" {
  description = "Enable AWS Foundational Security Best Practices standard."
  type        = bool
  default     = true
}

variable "enable_pci_dss_standard" {
  description = "Enable PCI DSS standard."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags applied to Security Hub resources (note: Security Hub itself is not taggable, but future resources in this module may use these)."
  type        = map(string)
  default     = {}
}
