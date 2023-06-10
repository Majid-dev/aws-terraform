
output "aws_iam_user_secret" {
  value     = aws_iam_access_key.access_key.secret
  sensitive = true
}

output "password" {
  value = aws_iam_user_login_profile.profile.password
}