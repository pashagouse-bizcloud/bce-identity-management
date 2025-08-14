resource "aws_iam_user" "users" {
  for_each = { for user in var.users : user.name => user }

  name = each.value.name
  path = "/bce-managed/"

  tags = {
    Email       = each.value.email
    ManagedBy   = "terraform"
    Environment = "dev"
  }
}

resource "aws_iam_access_key" "user_keys" {
  for_each = {
    for user in var.users : user.name => user
    if user.access_key_required
  }

  user = aws_iam_user.users[each.key].name
}

resource "aws_iam_user_group_membership" "user_groups" {
  for_each = {
    for user in var.users : user.name => user
    if length(user.groups) > 0
  }

  user   = aws_iam_user.users[each.key].name
  groups = each.value.groups
}