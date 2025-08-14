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

echo "📋 Choose your deployment approach:"
echo "1. IAM Users (Traditional)"
echo "2. Google SSO (SAML Federation)"
read -p "Enter your choice (1 or 2): " choice

case $choice in
    1)
        DEPLOYMENT_DIR="deployments/iam-users"
        echo "🔐 Setting up IAM Users deployment..."
        ;;
    2)
        DEPLOYMENT_DIR="deployments/google-sso"
        echo "🌐 Setting up Google SSO deployment..."
        ;;
    *)
        echo "❌ Invalid choice. Please run the script again."
        exit 1
        ;;
esac

# Navigate to deployment directory
cd $DEPLOYMENT_DIR

# Initialize Terraform
echo "📦 Initializing Terraform..."
terraform init

# Validate configuration
echo "✅ Validating Terraform configuration..."
terraform validate

# Format code
echo "🎨 Formatting Terraform code..."
terraform fmt -recursive

echo "✨ Setup complete for $DEPLOYMENT_DIR!"
echo ""
echo "📖 Next steps:"
if [ "$choice" = "1" ]; then
    echo "1. Update ../../config/users.yaml with your users"
    echo "2. Update ../../config/roles.yaml with your roles"
else
    echo "1. Follow the Google SSO setup guide in ../../docs/GOOGLE_SSO_SETUP.md"
    echo "2. Update ../../config/google-sso-roles.yaml with your role mappings"
fi
echo "3. Run 'terraform plan' to review changes"
echo "4. Run 'terraform apply' to create resources"
echo ""
echo "📁 Working directory: $(pwd)"