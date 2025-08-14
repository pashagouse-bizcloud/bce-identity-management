# S3 Backend Configuration Template
# Copy these values to your main.tf after running create-s3-backend.sh

terraform {
  backend "s3" {
    bucket         = "bce-identity-management-terraform-state"
    key            = "identity-management/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}

# Alternative: Use backend config file
# Create a file called backend.conf with:
# bucket         = "your-bucket-name"
# key            = "identity-management/terraform.tfstate"
# region         = "us-east-1"
# dynamodb_table = "terraform-state-lock"
# encrypt        = true
#
# Then run: terraform init -backend-config=backend.conf