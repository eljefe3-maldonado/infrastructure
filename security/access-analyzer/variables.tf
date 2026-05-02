variable "analyzer_name" {
  description = "IAM Access Analyzer name."
  type        = string
}

variable "analyzer_type" {
  description = "Analyzer scope: ACCOUNT or ORGANIZATION. ORGANIZATION requires AWS Organizations."
  type        = string
  default     = "ORGANIZATION"
}

variable "archive_rules" {
  description = "List of archive rules to suppress known-good findings."
  type = list(object({
    rule_name = string
    filter = list(object({
      criteria = string
      eq       = optional(list(string), [])
      neq      = optional(list(string), [])
      exists   = optional(bool)
    }))
  }))
  default = []
}

variable "tags" {
  description = "Tags applied to Access Analyzer resources."
  type        = map(string)
  default     = {}
}
