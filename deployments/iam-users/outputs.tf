output "created_users" {
  description = "List of created IAM users"
  value       = module.iam_users.user_names
}

output "created_roles" {
  description = "List of created IAM roles"
  value       = module.iam_roles.role_names
}

output "created_groups" {
  description = "List of created IAM groups"
  value       = module.iam_groups.group_names
}

output "access_keys" {
  description = "IAM user access keys (sensitive)"
  value       = module.iam_users.access_keys
  sensitive   = true
}

output "github_actions_role_arn" {
  description = "ARN of the GitHub Actions role"
  value       = aws_iam_role.github_actions.arn
}