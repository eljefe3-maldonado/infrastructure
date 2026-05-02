output "bucket_name" {
  description = "Log archive bucket name."
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "Log archive bucket ARN."
  value       = aws_s3_bucket.this.arn
}
