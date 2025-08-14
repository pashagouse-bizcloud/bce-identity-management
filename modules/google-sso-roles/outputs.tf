output "role_arns" {
  description = "ARNs of created Google SSO roles"
  value = {
    for k, v in aws_iam_role.google_sso_roles : k => v.arn
  }
}

output "role_names" {
  description = "Names of created Google SSO roles"
  value = {
    for k, v in aws_iam_role.google_sso_roles : k => v.name
  }
}

output "switch_role_urls" {
  description = "URLs for switching to roles in AWS console"
  value = {
    for k, v in aws_iam_role.google_sso_roles : k => 
    "https://signin.aws.amazon.com/switchrole?account=${split("-", k)[2]}&roleName=${v.name}&displayName=${k}"
  }
}