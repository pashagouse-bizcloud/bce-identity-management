#!/bin/bash

# Script to create S3 backend for Terraform state

# Configuration - UPDATE THESE VALUES
BUCKET_NAME="bce-identity-management-terraform-state"
AWS_REGION="us-east-1"
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

echo "🪣 Creating S3 backend for Terraform state..."
echo "Bucket name: $BUCKET_NAME"
echo "Region: $AWS_REGION"
echo "Account ID: $AWS_ACCOUNT_ID"

# Create the S3 bucket
echo "📦 Creating S3 bucket..."
aws s3 mb s3://$BUCKET_NAME --region $AWS_REGION

# Enable versioning (important for state file safety)
echo "🔄 Enabling versioning..."
aws s3api put-bucket-versioning \
    --bucket $BUCKET_NAME \
    --versioning-configuration Status=Enabled

# Enable server-side encryption
echo "🔒 Enabling encryption..."
aws s3api put-bucket-encryption \
    --bucket $BUCKET_NAME \
    --server-side-encryption-configuration '{
        "Rules": [
            {
                "ApplyServerSideEncryptionByDefault": {
                    "SSEAlgorithm": "AES256"
                }
            }
        ]
    }'

# Block public access (security)
echo "🛡️ Blocking public access..."
aws s3api put-public-access-block \
    --bucket $BUCKET_NAME \
    --public-access-block-configuration \
        BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true

# Create DynamoDB table for state locking
echo "🔐 Creating DynamoDB table for state locking..."
aws dynamodb create-table \
    --table-name terraform-state-lock \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
    --region $AWS_REGION

echo "✅ S3 backend setup complete!"
echo ""
echo "📝 Update your main.tf with these values:"
echo ""
echo "backend \"s3\" {"
echo "  bucket         = \"$BUCKET_NAME\""
echo "  key            = \"identity-management/terraform.tfstate\""
echo "  region         = \"$AWS_REGION\""
echo "  dynamodb_table = \"terraform-state-lock\""
echo "  encrypt        = true"
echo "}"