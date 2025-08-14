terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "bce-identity-management-terraform-state"
    key            = "identity-management/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}

# Load user configurations
locals {
  users_config = yamldecode(file("${path.module}/config/users.yaml"))
  roles_config = yamldecode(file("${path.module}/config/roles.yaml"))
}

# Extract unique group names from users
locals {
  all_groups    = flatten([for user in local.users_config.users : user.groups])
  unique_groups = toset(local.all_groups)
}

# Create IAM groups first
module "iam_groups" {
  source = "./modules/iam-groups"

  group_names = local.unique_groups
  group_policies = {
    "developers" = "arn:aws:iam::aws:policy/PowerUserAccess"
    "admins"     = "arn:aws:iam::aws:policy/AdministratorAccess"
    "billing"    = "arn:aws:iam::aws:policy/job-function/Billing"
    "s3-read"    = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
    "ec2-manage" = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  }
}

# Create IAM users (depends on groups)
module "iam_users" {
  source = "./modules/iam-users"

  users = local.users_config.users

  depends_on = [module.iam_groups]
}

# Create IAM roles
module "iam_roles" {
  source = "./modules/iam-roles"

  roles = local.roles_config.roles
}

# GitHub Actions OIDC Provider and Role
resource "aws_iam_openid_connect_provider" "github_actions" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1"
  ]

  tags = {
    Purpose   = "GitHub Actions OIDC"
    ManagedBy = "terraform"
  }
}

resource "aws_iam_role" "github_actions" {
  name = "GitHubActionsRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github_actions.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:*/bce-identity-management:*"
          }
        }
      }
    ]
  })

  tags = {
    Purpose   = "GitHub Actions"
    ManagedBy = "terraform"
  }
}

resource "aws_iam_role_policy_attachment" "github_actions_policy" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}

# Add S3 and DynamoDB permissions for Terraform state backend
resource "aws_iam_role_policy" "github_actions_terraform_backend" {
  name = "TerraformBackendAccess"
  role = aws_iam_role.github_actions.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::bce-identity-management-terraform-state",
          "arn:aws:s3:::bce-identity-management-terraform-state/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem"
        ]
        Resource = "arn:aws:dynamodb:us-east-1:*:table/terraform-state-lock"
      }
    ]
  })
}