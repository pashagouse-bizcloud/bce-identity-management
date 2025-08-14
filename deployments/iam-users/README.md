# IAM Users Deployment

This deployment creates traditional IAM users, groups, and roles for identity management.

## What This Creates

- **IAM Users**: Individual users with programmatic access
- **IAM Groups**: Groups with specific permissions (developers, admins, billing, etc.)
- **IAM Roles**: Service roles for applications
- **Access Keys**: Programmatic access credentials for users
- **GitHub Actions Role**: For CI/CD pipeline access

## Configuration Files

- `../../config/users.yaml` - Define users and their group memberships
- `../../config/roles.yaml` - Define service roles

## Usage

1. **Configure Users**: Edit `config/users.yaml` to define your users:
   ```yaml
   users:
     - username: "john.doe"
       groups: ["developers", "s3-read"]
     - username: "jane.admin"
       groups: ["admins"]
   ```

2. **Initialize Terraform**:
   ```bash
   cd deployments/iam-users
   terraform init
   ```

3. **Plan and Apply**:
   ```bash
   terraform plan
   terraform apply
   ```

## Outputs

- `created_users` - List of created IAM users
- `created_groups` - List of created IAM groups
- `created_roles` - List of created IAM roles
- `access_keys` - Access keys for users (sensitive)
- `github_actions_role_arn` - GitHub Actions role ARN

## Security Considerations

- Access keys are sensitive and should be stored securely
- Users should enable MFA after initial setup
- Rotate access keys regularly
- Follow principle of least privilege

## When to Use This Approach

- Small to medium teams
- Need direct AWS API access
- Traditional IAM management preferred
- No external identity provider integration needed