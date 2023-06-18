resource "aws_iam_group" "example_group" {
  name = var.group_name
}

resource "aws_iam_user" "example_user" {
  name = var.user_name
}

resource "aws_iam_group_policy_attachment" "example_group_policy" {
  group      = aws_iam_group.example_group.name
  policy_arn = aws_iam_policy.example_group_policy.arn
}

resource "aws_iam_user_policy_attachment" "example_user_policy" {
  user       = aws_iam_user.example_user.name
  policy_arn = aws_iam_policy.example_user_policy.arn
}

resource "aws_iam_policy" "example_group_policy" {
  name        = var.group_policy_name
  description = "Example group policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::example-bucket"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_policy" "example_user_policy" {
  name        = var.user_policy_name
  description = "Example user policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": [
        "arn:aws:s3:::example-bucket/*"
      ]
    }
  ]
}
EOF
}
