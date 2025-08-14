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
    key            = "google-sso/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}

# Load Google SSO configuration
locals {
  google_sso_config = yamldecode(file("${path.module}/../../config/google-sso-roles.yaml"))
}

# Create Google SSO roles
module "google_sso_roles" {
  source = "../../modules/google-sso-roles"

  accounts    = local.google_sso_config.accounts
  environment = var.environment
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
  name = "GitHubActionsRole-GoogleSSO"

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
    Purpose   = "GitHub Actions - Google SSO"
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