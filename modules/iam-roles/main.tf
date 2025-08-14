data "aws_iam_policy_document" "assume_role_policy" {
  for_each = { for role in var.roles : role.name => role }
  
  statement {
    actions = ["sts:AssumeRole"]
    
    principals {
      type        = "Service"
      identifiers = ["${each.value.assume_role_policy}.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "roles" {
  for_each = { for role in var.roles : role.name => role }
  
  name               = each.value.name
  description        = each.value.description
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy[each.key].json
  
  tags = {
    ManagedBy   = "terraform"
    Environment = "production"
  }
}

resource "aws_iam_role_policy_attachment" "managed_policies" {
  for_each = {
    for pair in flatten([
      for role in var.roles : [
        for policy in role.managed_policies : {
          role_name  = role.name
          policy_arn = policy
          key        = "${role.name}-${policy}"
        }
      ]
    ]) : pair.key => pair
  }
  
  role       = aws_iam_role.roles[each.value.role_name].name
  policy_arn = each.value.policy_arn
}