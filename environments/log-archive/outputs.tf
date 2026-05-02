output "log_archive_bucket_name" {
  description = "Centralized log archive bucket name."
  value       = module.log_archive_bucket.bucket_name
}

output "log_archive_kms_key_arn" {
  description = "KMS key ARN for log archive encryption."
  value       = module.log_archive_kms_key.key_arn
}

output "log_archive_bucket_arn" {
  description = "Centralized log archive bucket ARN for cross-account policy references."
  value       = module.log_archive_bucket.bucket_arn
}

output "log_archive_kms_key_id" {
  description = "KMS key ID for backend configuration."
  value       = module.log_archive_kms_key.key_id
}
