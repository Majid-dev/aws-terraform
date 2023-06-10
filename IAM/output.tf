
output "aws_iam_user_secret" {
  value = aws_iam_access_key.keyuser.secret
  sensitive = true
}