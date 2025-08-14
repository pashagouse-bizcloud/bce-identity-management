# BCE Identity Management

Automated AWS Identity and Access Management through Infrastructure as Code.

## Overview

This project provides **two distinct approaches** for AWS Identity and Access Management (IAM):

### 🔐 IAM Users Approach (`deployments/iam-users/`)
Traditional IAM users with programmatic access keys. Best for:
- Small to medium teams
- Direct AWS API access needs
- Traditional IAM management preferences
- No external identity provider integration

### 🌐 Google SSO Approach (`deployments/google-sso/`)
SAML federation with Google Workspace. Best for:
- Medium to large organizations
- Existing Google Workspace users
- Eliminating long-term AWS credentials
- Centralized identity management
- Strong audit and compliance requirements

## Quick Start

Choose your preferred approach:

### For IAM Users:
```bash
cd deployments/iam-users
terraform init
terraform plan
terraform apply
```

### For Google SSO:
```bash
cd deployments/google-sso
terraform init
terraform plan
terraform apply
```

## Project Structure
```
├── deployments/
│   ├── iam-users/         # Traditional IAM users deployment
│   └── google-sso/        # Google SSO SAML federation
├── modules/               # Reusable Terraform modules
├── config/               # Configuration files
├── .github/workflows/    # Separate CI/CD for each approach
├── docs/                 # Documentation
└── scripts/              # Helper utilities
```

## Configuration Files

- `config/users.yaml` - IAM users and groups (for IAM users approach)
- `config/roles.yaml` - Service roles (for IAM users approach)  
- `config/google-sso-roles.yaml` - Google SSO role mappings (for Google SSO approach)

## GitHub Actions

Each approach has its own workflow:
- **IAM Users**: `.github/workflows/iam-users.yml`
- **Google SSO**: `.github/workflows/google-sso.yml`

Workflows trigger based on file changes in their respective directories.