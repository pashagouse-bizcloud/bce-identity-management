#!/bin/bash

# BCE Identity Management Setup Script

echo "🚀 Setting up BCE Identity Management..."

# Check if Terraform is installed
if ! command -v terraform &> /dev/null; then
    echo "❌ Terraform is not installed. Please install Terraform first."
    exit 1
fi

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "❌ AWS CLI is not installed. Please install AWS CLI first."
    exit 1
fi

# Initialize Terraform
echo "📦 Initializing Terraform..."
terraform init

# Validate configuration
echo "✅ Validating Terraform configuration..."
terraform validate

# Format code
echo "🎨 Formatting Terraform code..."
terraform fmt -recursive

echo "✨ Setup complete! Next steps:"
echo "1. Configure your S3 backend in main.tf"
echo "2. Update config/users.yaml with your users"
echo "3. Update config/roles.yaml with your roles"
echo "4. Run 'terraform plan' to review changes"
echo "5. Run 'terraform apply' to create resources"