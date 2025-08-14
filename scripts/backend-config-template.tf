# S3 Backend Configuration Template
# The backend configuration is already included in each deployment

# For IAM Users deployment:
terraform {
  backend "s3" {
    bucket         = "bce-identity-management-terraform-state"
    key            = "iam-users/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}

# For Google SSO deployment:
terraform {
  backend "s3" {
    bucket         = "bce-identity-management-terraform-state"
    key            = "google-sso/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}

# Note: Each deployment uses a different state file key to avoid conflicts