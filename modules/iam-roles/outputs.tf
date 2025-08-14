output "role_names" {
  description = "Names of created roles"
  value       = [for role in aws_iam_role.roles : role.name]
}

output "role_arns" {
  description = "ARNs of created roles"
  value       = [for role in aws_iam_role.roles : role.arn]
}