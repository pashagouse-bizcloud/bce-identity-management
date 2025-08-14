variable "accounts" {
  description = "List of AWS accounts with their Google SSO role mappings"
  type = list(object({
    account_id   = string
    account_name = string
    roles = list(object({
      role_name     = string
      description   = string
      google_users  = list(string)
      google_groups = list(string)
    }))
  }))
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}