output "role_arn" {
  description = "Break-glass role ARN"
  value       = aws_iam_role.break_glass.arn
}

output "role_name" {
  description = "Break-glass role name"
  value       = aws_iam_role.break_glass.name
}

output "role_unique_id" {
  description = "Break-glass role unique ID"
  value       = aws_iam_role.break_glass.unique_id
}
