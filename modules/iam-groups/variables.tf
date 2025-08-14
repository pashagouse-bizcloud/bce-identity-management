variable "group_names" {
  description = "List of IAM group names to create"
  type        = list(string)
}

variable "group_policies" {
  description = "Map of group names to policy ARNs"
  type        = map(string)
  default     = {}
}