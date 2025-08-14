# Deployment Options

This directory contains two separate deployment approaches for AWS Identity Management. Choose the one that best fits your organization's needs.

## 🔐 IAM Users (`iam-users/`)

**Traditional IAM users with programmatic access**

### Pros:
- ✅ Simple setup and management
- ✅ Direct AWS API access
- ✅ No external dependencies
- ✅ Full control over user lifecycle
- ✅ Works with any email provider

### Cons:
- ❌ Long-term credentials to manage
- ❌ Manual access key rotation
- ❌ No centralized identity provider
- ❌ Separate MFA setup required

### Best For:
- Small to medium teams (< 50 users)
- Development environments
- Teams without Google Workspace
- Simple access patterns

---

## 🌐 Google SSO (`google-sso/`)

**SAML federation with Google Workspace**

### Pros:
- ✅ No long-term AWS credentials
- ✅ Centralized identity management
- ✅ Automatic user provisioning/deprovisioning
- ✅ Leverages existing Google MFA
- ✅ Better audit trail and compliance
- ✅ Single sign-on experience

### Cons:
- ❌ Requires Google Workspace
- ❌ More complex initial setup
- ❌ SAML configuration needed
- ❌ Dependency on Google services

### Best For:
- Medium to large organizations (50+ users)
- Companies already using Google Workspace
- Production environments
- Compliance-focused organizations

---

## Decision Matrix

| Factor | IAM Users | Google SSO |
|--------|-----------|------------|
| **Team Size** | < 50 users | 50+ users |
| **Google Workspace** | Not required | Required |
| **Setup Complexity** | Simple | Moderate |
| **Security** | Good | Excellent |
| **Compliance** | Basic | Advanced |
| **Maintenance** | Manual | Automated |
| **Cost** | Low | Medium |

## Getting Started

1. **Choose your approach** based on the criteria above
2. **Read the specific README** in your chosen directory
3. **Configure the YAML files** in the `config/` directory
4. **Deploy using Terraform** from your chosen deployment directory

## Can I Use Both?

**No, these are mutually exclusive approaches.** They manage the same AWS resources (IAM roles, users, etc.) and would conflict with each other. Choose one approach for your organization.

## Migration

If you need to migrate from one approach to another:
1. Export existing configurations
2. Destroy the old deployment
3. Configure the new approach
4. Deploy the new approach

See the migration guide in `docs/` for detailed steps.