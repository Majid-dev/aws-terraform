variable "iam_user_name" {
  default = "test-user"
}

variable "iam_group_name" {
  default = "test-group"
}

variable "iam_user_policy_name" {
  default = "test_policy"
}

variable "iam_group_membership" {
  default = "tf-testing-group-membership"
}

variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "aws_region" {
  default = "us-east-1"
}