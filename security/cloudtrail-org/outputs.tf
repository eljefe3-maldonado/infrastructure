output "trail_arn" {
  description = "CloudTrail trail ARN."
  value       = aws_cloudtrail.this.arn
}

output "trail_name" {
  description = "CloudTrail trail name."
  value       = aws_cloudtrail.this.name
}

output "trail_home_region" {
  description = "Home region of the CloudTrail trail."
  value       = aws_cloudtrail.this.home_region
}
