locals {
  role_policies = {
    readonly = [
      "ReadOnlyAccess"
    ],
    admin = [
      "AdministratorAccess"
    ],
    developer = [
      "AmazonS3FullAccess",
      "AmazonEC2FullAccess",
      "AmazonRDSFullAccess",
      "AmazonRDSFullAccess"
    ],
    sales = [
      "AmazonDynamoDBFullAccess",
      "AmazonS3ReadOnlyAccess"
    ],
    auditor = [
      "SecurityAudit"
    ]
  }
  role_policies_list = flatten([for role, policies in local.role_policies :[for policy in policies : {role = role, policy = policy}]])
}

output "role_policies_list" {
  value = local.role_policies_list
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "assume_role" {
    for_each = toset(keys(local.role_policies))
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [
        for username in keys(aws_iam_user.users) : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${username}"
        if contains(local.users_map[username], each.key)]
    }
  }

}

resource "aws_iam_role" "roles" {
  for_each           = toset(keys(local.role_policies))
  name               = each.key
  assume_role_policy = data.aws_iam_policy_document.assume_role[each.value].json
}

data "aws_iam_policy" "managed_policy" {
  for_each = toset(local.role_policies_list[*].policy)
  arn      = "arn:aws:iam::aws:policy/${each.key}"
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  count = length(local.role_policies_list)
  role  = aws_iam_role.roles[local.role_policies_list[count.index].role].name
  policy_arn = data.aws_iam_policy.managed_policy[local.role_policies_list[count.index].policy].arn
}