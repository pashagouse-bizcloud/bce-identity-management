resource "aws_iam_group" "groups" {
  for_each = toset(var.group_names)
  
  name = each.value
  path = "/bce-managed/"
}

# Attach policies to groups
resource "aws_iam_group_policy_attachment" "group_policies" {
  for_each = var.group_policies
  
  group      = aws_iam_group.groups[each.key].name
  policy_arn = each.value
}