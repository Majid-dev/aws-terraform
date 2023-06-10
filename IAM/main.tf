resource "aws_iam_user" "testuser" {
  name = var.iam_user_name
  path = "/system/"

}

resource "aws_iam_user_login_profile" "profile" {
  user    = aws_iam_user.testuser.name
}

resource "aws_iam_access_key" "keyuser" {
  user = aws_iam_user.testuser.name
}

data "aws_iam_policy_document" "testuser_ro" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:Describe*"]
    resources = ["*"]
  }
}

resource "aws_iam_user_policy" "testuser_ro" {
  name   = var.iam_user_policy_name
  user   = aws_iam_user.testuser.name
  policy = data.aws_iam_policy_document.testuser_ro.json
}

resource "aws_iam_group_membership" "team" {
  name = var.iam_group_membership

  users = [
    aws_iam_user.testuser.name
  ]

  group = aws_iam_group.group.name
}

resource "aws_iam_group" "group" {
  name = var.iam_group_name
}

