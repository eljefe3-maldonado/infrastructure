variable "detector_enable" {
  description = "Enable the GuardDuty detector."
  type        = bool
  default     = true
}

variable "finding_publishing_frequency" {
  description = "Frequency of GuardDuty findings publication: FIFTEEN_MINUTES, ONE_HOUR, or SIX_HOURS."
  type        = string
  default     = "SIX_HOURS"
}

variable "datasources_enable_s3" {
  description = "Enable S3 protection."
  type        = bool
  default     = true
}

variable "datasources_enable_kubernetes" {
  description = "Enable Kubernetes audit logs protection."
  type        = bool
  default     = true
}

variable "datasources_enable_malware_protection" {
  description = "Enable EBS malware protection."
  type        = bool
  default     = true
}

variable "delegated_admin_account_id" {
  description = "Account ID to delegate GuardDuty administration. Leave empty to skip delegation."
  type        = string
  default     = ""
}

variable "auto_enable_org_members" {
  description = "How to auto-enable members: ALL, NEW, or NONE."
  type        = string
  default     = "ALL"
}

variable "enable_s3_logs_for_org" {
  description = "Auto-enable S3 logs for org members."
  type        = bool
  default     = true
}

variable "enable_kubernetes_for_org" {
  description = "Auto-enable Kubernetes protection for org members."
  type        = bool
  default     = true
}

variable "enable_malware_protection_for_org" {
  description = "Auto-enable malware protection for org members."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags applied to GuardDuty resources."
  type        = map(string)
  default     = {}
}
