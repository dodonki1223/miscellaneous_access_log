output "iam_role_arn" {
  description = "iam role arn"
  value       = aws_iam_role.default.arn
}

output "iam_role_name" {
  description = "iam role name"
  value       = aws_iam_role.default.name
}
