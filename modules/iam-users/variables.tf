variable "users" {
  description = "List of users to create"
  type = list(object({
    name                = string
    email               = string
    groups              = optional(list(string), [])
    access_key_required = bool
  }))
}