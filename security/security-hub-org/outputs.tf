output "account_id" {
  description = "Security Hub account resource ID."
  value       = try(aws_securityhub_account.this[0].id, "")
}

output "cis_subscription_arn" {
  description = "CIS AWS Foundations Benchmark standards subscription ARN. Empty string if not enabled."
  value       = try(aws_securityhub_standards_subscription.cis[0].id, "")
}

output "fsbp_subscription_arn" {
  description = "AWS Foundational Security Best Practices standards subscription ARN. Empty string if not enabled."
  value       = try(aws_securityhub_standards_subscription.fsbp[0].id, "")
}
