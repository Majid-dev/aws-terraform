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

variable "cidr_blocks" {
  default = "0.0.0.0/0"
}


variable "entry_script_file" {
  default = "entryscript.sh"
}

variable "gp_protocol" {
  default = "tcp"
}

variable "instance_list" {
  default = ["web_server_1", "web_server_2", "web_server_3"]
}