variable "iam_user_name" {
  default = "opt-user"
}

variable "iam_group_name" {
  default = "operation-group"
}

variable "iam_user_policy_name" {
  default = "user_policy"
}

variable "iam_group_membership" {
  default = "group-membership"
}

variable "iam_group_policy_name" {
  default = "group_policy"
}

variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "aws_region" {
  default = "us-east-1"
}