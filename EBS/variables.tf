variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "aws_region" {
  default = "us-east-1"
}

variable "default_az" {
  default = "us-east-1d"
}

variable "instance_type" {
  default = "t2.micro"
}
