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
  google_sso_config = yamldecode(file("${path.module}/config/google-sso-roles.yaml"))
}

# Create Google SSO roles
module "google_sso_roles" {
  source = "./modules/google-sso-roles"
  
  accounts    = local.google_sso_config.accounts
  environment = var.environment
}

# Variables
variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

# Outputs
output "google_sso_roles" {
  description = "Google SSO role information"
  value       = module.google_sso_roles.role_arns
}

output "switch_role_urls" {
  description = "URLs for switching roles in AWS console"
  value       = module.google_sso_roles.switch_role_urls
}