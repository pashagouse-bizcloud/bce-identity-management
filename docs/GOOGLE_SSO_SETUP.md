# Google SSO Integration Setup

## Overview
This setup creates AWS IAM roles that can be assumed by Google SSO users, replacing manual Google Workspace provisioning.

## How It Works

### Current Manual Process:
1. Admin manually grants access in Google Workspace
2. User switches role: Account `123456789012`, Role `power-user-role`
3. No tracking of who has what access

### New Automated Process:
1. Update `config/google-sso-roles.yaml`
2. Run `terraform apply`
3. Roles automatically created with proper Google SSO trust relationships
4. Full audit trail in Git

## Configuration

### google-sso-roles.yaml Structure:
```yaml
accounts:
  - account_id: "123456789012"
    account_name: "ams-ai-dev"
    roles:
      - role_name: "power-user-role"
        google_users:
          - "user@company.com"
        google_groups:
          - "developers@company.com"
```

## Usage

### Deploy Google SSO Roles:
```bash
# Use the Google SSO configuration
terraform init -backend-config="key=google-sso/terraform.tfstate"
terraform plan -var-file="google-sso.tfvars"
terraform apply
```

### Switch Role (Same as Before):
- Account: `123456789012`
- Role: `power-user-role`
- Display Name: `ams-ai-dev-power-user-role`

## Benefits

1. **Code-Driven**: All access defined in YAML
2. **Audit Trail**: Git history shows all changes
3. **Automated**: No manual Google Workspace steps
4. **Scalable**: Easy to add new accounts/roles
5. **Trackable**: Clear visibility of who has access where

## Migration Strategy

1. **Phase 1**: Deploy alongside existing manual process
2. **Phase 2**: Migrate users to new roles gradually  
3. **Phase 3**: Deprecate manual Google Workspace process

## Role Naming Convention

- `power-user-role`: PowerUser access (most developers)
- `admin-role`: Full administrative access
- `read-only-role`: Read-only access
- `billing-role`: Billing and cost management

## Adding New Access

To give someone access to `ams-ai-prod` account:

1. Edit `config/google-sso-roles.yaml`
2. Add their email to appropriate role
3. Commit and push (triggers GitHub Actions)
4. User can immediately switch to the role