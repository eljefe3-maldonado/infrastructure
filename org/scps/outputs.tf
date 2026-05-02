output "deny_root_policy_arn" {
  description = "ARN of the deny-root-account-actions SCP"
  value       = try(aws_organizations_policy.deny_root[0].arn, "")
}

output "deny_leave_org_policy_arn" {
  description = "ARN of the deny-leaving-organization SCP"
  value       = try(aws_organizations_policy.deny_leave_org[0].arn, "")
}

output "deny_public_s3_policy_arn" {
  description = "ARN of the deny-s3-public-access-modification SCP"
  value       = try(aws_organizations_policy.deny_public_s3[0].arn, "")
}

output "deny_unapproved_regions_policy_arn" {
  description = "ARN of the deny-unapproved-regions SCP"
  value       = try(aws_organizations_policy.deny_unapproved_regions[0].arn, "")
}

output "require_imdsv2_policy_arn" {
  description = "ARN of the require-imdsv2 SCP"
  value       = try(aws_organizations_policy.require_imdsv2[0].arn, "")
}

output "deny_cloudtrail_disable_policy_arn" {
  description = "ARN of the deny-cloudtrail-modification SCP"
  value       = try(aws_organizations_policy.deny_cloudtrail_disable[0].arn, "")
}
