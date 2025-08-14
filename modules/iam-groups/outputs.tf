output "group_names" {
  description = "Names of created groups"
  value       = [for group in aws_iam_group.groups : group.name]
}

output "group_arns" {
  description = "ARNs of created groups"
  value       = [for group in aws_iam_group.groups : group.arn]
}