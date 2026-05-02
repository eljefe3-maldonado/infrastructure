output "state_bucket_name" {
  description = "S3 bucket name for Terraform remote state."
  value       = aws_s3_bucket.state.id
}

output "state_bucket_arn" {
  description = "S3 bucket ARN for Terraform remote state."
  value       = aws_s3_bucket.state.arn
}

output "lock_table_name" {
  description = "DynamoDB table name for Terraform state locking."
  value       = aws_dynamodb_table.lock.name
}

output "kms_key_arn" {
  description = "KMS key ARN used for remote state encryption."
  value       = aws_kms_key.state.arn
}
