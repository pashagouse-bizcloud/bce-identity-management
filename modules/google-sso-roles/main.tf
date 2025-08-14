# Create IAM roles that can be assumed by Google SSO users
resource "aws_iam_role" "google_sso_roles" {
  for_each = {
    for role in local.all_roles : "${role.account_name}-${role.role_name}" => role
  }
  
  name        = each.value.role_name
  description = each.value.description
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${each.value.account_id}:saml-provider/GoogleSSO"
        }
        Action = "sts:AssumeRoleWithSAML"
        Condition = {
          StringEquals = {
            "SAML:aud" = "https://signin.aws.amazon.com/saml"
          }
          # Add conditions for specific Google users/groups
          ForAnyValue:StringLike = {
            "SAML:email" = concat(
              each.value.google_users,
              [for group in each.value.google_groups : "*@${split("@", group)[1]}"]
            )
          }
        }
      }
    ]
  })
  
  tags = {
    ManagedBy    = "terraform"
    Account      = each.value.account_name
    GoogleSSO    = "true"
    Environment  = var.environment
  }
}

# Attach appropriate policies to roles
resource "aws_iam_role_policy_attachment" "google_sso_role_policies" {
  for_each = {
    for role in local.all_roles : "${role.account_name}-${role.role_name}" => role
  }
  
  role       = aws_iam_role.google_sso_roles[each.key].name
  policy_arn = local.role_policy_mapping[each.value.role_name]
}

# Local values for processing the configuration
locals {
  # Flatten the nested structure for easier processing
  all_roles = flatten([
    for account in var.accounts : [
      for role in account.roles : {
        account_id   = account.account_id
        account_name = account.account_name
        role_name    = role.role_name
        description  = role.description
        google_users = role.google_users
        google_groups = role.google_groups
      }
    ]
  ])
  
  # Map role names to AWS managed policies
  role_policy_mapping = {
    "power-user-role" = "arn:aws:iam::aws:policy/PowerUserAccess"
    "admin-role"      = "arn:aws:iam::aws:policy/AdministratorAccess"
    "read-only-role"  = "arn:aws:iam::aws:policy/ReadOnlyAccess"
    "billing-role"    = "arn:aws:iam::aws:policy/job-function/Billing"
  }
}