output "detector_id" {
  description = "GuardDuty detector ID."
  value       = aws_guardduty_detector.this.id
}

output "detector_arn" {
  description = "GuardDuty detector ARN."
  value       = aws_guardduty_detector.this.arn
}

output "account_id" {
  description = "AWS account ID where the detector was created."
  value       = data.aws_caller_identity.current.account_id
}
