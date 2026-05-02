output "cloudtrail_arn" {
  description = "ARN of the organization CloudTrail"
  value       = module.org_trail.trail_arn
}

output "guardduty_detector_id" {
  description = "ID of the GuardDuty detector"
  value       = module.guardduty.detector_id
}

output "access_analyzer_arn" {
  description = "ARN of the IAM Access Analyzer"
  value       = module.access_analyzer.analyzer_arn
}
