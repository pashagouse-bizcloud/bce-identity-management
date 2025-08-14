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
  all_groups = flatten([for user in local.users_config.users : user.groups])
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