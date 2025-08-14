# Google SSO Deployment

This deployment creates IAM roles that can be assumed by Google Workspace users through SAML federation.

## What This Creates

- **IAM Roles**: Roles that can be assumed by Google SSO users
- **SAML Identity Provider**: Integration with Google Workspace
- **Role Mappings**: Map Google users/groups to AWS roles
- **GitHub Actions Role**: For CI/CD pipeline access

## Prerequisites

1. **Google Workspace Admin Access**: You need admin access to configure SAML
2. **AWS Account**: Target AWS account for role creation
3. **SAML Provider Setup**: Follow the Google SSO setup guide

## Configuration Files

- `../../config/google-sso-roles.yaml` - Define roles and Google user mappings
- `../../docs/GOOGLE_SSO_SETUP.md` - Detailed setup instructions

## Usage

1. **Configure Google SSO**: Follow the setup guide in `docs/GOOGLE_SSO_SETUP.md`

2. **Configure Roles**: Edit `config/google-sso-roles.yaml`:
   ```yaml
   accounts:
     - account_id: "123456789012"
       account_name: "production"
       roles:
         - role_name: "admin-role"
           description: "Full admin access"
           google_users: ["admin@company.com"]
           google_groups: ["aws-admins@company.com"]
   ```

3. **Initialize Terraform**:
   ```bash
   cd deployments/google-sso
   terraform init
   ```

4. **Plan and Apply**:
   ```bash
   terraform plan
   terraform apply
   ```

## Outputs

- `google_sso_roles` - List of created Google SSO roles
- `google_sso_role_arns` - ARNs of created roles
- `github_actions_role_arn` - GitHub Actions role ARN

## Security Benefits

- **No Long-term Credentials**: No access keys to manage
- **Centralized Identity**: Use existing Google Workspace accounts
- **MFA Integration**: Leverage Google's MFA capabilities
- **Audit Trail**: Centralized logging through Google Workspace
- **Automatic Deprovisioning**: Users lose access when removed from Google

## When to Use This Approach

- Medium to large organizations
- Already using Google Workspace
- Want to eliminate long-term AWS credentials
- Need centralized identity management
- Require strong audit and compliance capabilities

## Role Mapping

Roles are mapped to Google users/groups based on email addresses:
- **Individual Users**: `user@company.com`
- **Google Groups**: `group@company.com` (all members get access)
- **Domain Wildcards**: `*@company.com` (all users in domain)