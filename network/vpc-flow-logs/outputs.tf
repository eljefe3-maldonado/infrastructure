output "flow_log_id" {
  description = "VPC Flow Log ID"
  value       = aws_flow_log.this.id
}

output "flow_log_arn" {
  description = "VPC Flow Log ARN"
  value       = aws_flow_log.this.arn
}
