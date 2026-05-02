output "recorder_id" {
  description = "AWS Config configuration recorder ID."
  value       = aws_config_configuration_recorder.this.id
}

output "delivery_channel_id" {
  description = "AWS Config delivery channel ID."
  value       = aws_config_delivery_channel.this.id
}

output "config_role_arn" {
  description = "IAM role ARN used by AWS Config."
  value       = local.config_role_arn
}
