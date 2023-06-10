#Create an IAM user with console access and key access

resource "aws_iam_user" "opt_user" {
  name = var.iam_user_name
  path = "/system/"

}

resource "aws_iam_user_login_profile" "profile" {
  user = aws_iam_user.opt_user.name
}

resource "aws_iam_access_key" "access_key" {
  user = aws_iam_user.opt_user.name
}

data "aws_iam_policy_document" "policy_doc" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:Describe*"]
    resources = ["*"]
  }
}

resource "aws_iam_user_policy" "user_policy" {
  name   = var.iam_user_policy_name
  user   = aws_iam_user.opt_user.name
  policy = data.aws_iam_policy_document.policy_doc.json
}

resource "aws_iam_group_policy" "group_policy" {
  name   = var.iam_group_policy_name
  policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "VisualEditor0",
			"Effect": "Allow",
			"Action": [
				"access-analyzer:ListAnalyzers",
				"access-analyzer:GetGeneratedPolicy",
				"access-analyzer:ValidatePolicy",
				"access-analyzer:ListPolicyGenerations"
			],
			"Resource": "*"
		}
	]
}
EOF

  group = aws_iam_group.operation.name
}

resource "aws_iam_group_membership" "team" {
  name = var.iam_group_membership

  users = [
    aws_iam_user.opt_user.name
  ]

  group = aws_iam_group.operation.name
}

resource "aws_iam_group" "operation" {
  name = var.iam_group_name
}

