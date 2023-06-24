variable "aws_access_key" {}
variable "aws_secret_key" {}

#VPC variables
variable "region" {}
variable "vpc_cidr_block" {}
variable "project_name" {}
variable "subnet_az1_cidr_block" {}
variable "subnet_az2_cidr_block" {}

#IAM variables
variable "group_name" {}
variable "user_name" {}
variable "group_policy_name" {}
variable "user_policy_name" {}

#launch template variables
variable "instance_type" {}
variable "user_data_file" {}

#target group variables
variable "health_check_path" {}
variable "tg_port" {}
variable "tg_protocol" {}
variable "tg_target_type" {}

#auto scaling group variables
variable "desired_capacity" {}
variable "max_size" {}
variable "min_size" {}

#Relational Database Service variables
variable "db_instance_identifier" {}
variable "instance_class" {}
variable "allocated_storage" {}
variable "db_name" {}
variable "db_username" {}
variable "db_password" {}
variable "create_read_replica" {}