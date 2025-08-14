output "created_users" {
  description = "List of created IAM users"
  value       = module.iam_users.user_names
}

output "created_roles" {
  description = "List of created IAM roles"
  value       = module.iam_roles.role_names
}

output "access_keys" {
  description = "IAM user access keys (sensitive)"
  value       = module.iam_users.access_keys
  sensitive   = true
}