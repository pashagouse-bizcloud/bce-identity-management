# BCE Identity Management

Automated AWS Identity and Access Management through Infrastructure as Code.

## Overview
This project automates AWS account access provisioning, replacing manual Google Workspace processes with code-driven workflows.

## Architecture
- **Terraform Modules**: Reusable IAM components
- **GitHub Actions**: Automated deployment pipeline  
- **Configuration Files**: Declarative access definitions
- **State Management**: Centralized permission tracking

## Quick Start
1. Configure AWS credentials
2. Update user configurations in `config/users.yaml`
3. Commit changes to trigger automated provisioning

## Structure
```
├── modules/           # Reusable Terraform modules
├── environments/      # Environment-specific configs
├── config/           # User and role definitions
├── .github/workflows/ # CI/CD automation
└── scripts/          # Helper utilities
```