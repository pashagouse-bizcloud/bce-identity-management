terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  backend "s3" {
    # Configure your S3 backend here
    # bucket = "your-terraform-state-bucket"
    # key    = "identity-management/terraform.tfstate"
    # region = "us-east-1"
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

# Create IAM users and roles
module "iam_users" {
  source = "./modules/iam-users"
  
  users = local.users_config.users
}

module "iam_roles" {
  source = "./modules/iam-roles"
  
  roles = local.roles_config.roles
}