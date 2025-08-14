output "google_sso_roles" {
  description = "List of created Google SSO roles"
  value       = module.google_sso_roles.role_names
}

output "google_sso_role_arns" {
  description = "ARNs of created Google SSO roles"
  value       = module.google_sso_roles.role_arns
}

output "github_actions_role_arn" {
  description = "ARN of the GitHub Actions role"
  value       = aws_iam_role.github_actions.arn
}