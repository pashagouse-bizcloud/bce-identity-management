output "user_names" {
  description = "Names of created users"
  value       = [for user in aws_iam_user.users : user.name]
}

output "access_keys" {
  description = "Access keys for users"
  value = {
    for k, v in aws_iam_access_key.user_keys : k => {
      access_key_id     = v.id
      secret_access_key = v.secret
    }
  }
  sensitive = true
}