variable "roles" {
  description = "List of IAM roles to create"
  type = list(object({
    name                = string
    description         = string
    assume_role_policy  = string
    managed_policies    = list(string)
  }))
}