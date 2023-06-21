#VPC variables
region                = "us-east-1"
vpc_cidr_block        = "10.0.0.0/16"
project_name          = "jupiter"
subnet_az1_cidr_block = "10.0.1.0/24"
subnet_az2_cidr_block = "10.0.2.0/24"

#IAM variables
group_name        = "ex-group"
user_name         = "ex-user"
group_policy_name = "gp-name"
user_policy_name  = "up-name"

#launch template variables
instance_type  = "t2.micro"
user_data_file = "./modules/launch-template/entryscript.sh"

#target group variables
health_check_path = "/"
tg_port           = 80
tg_protocol       = "HTTP"
tg_target_type    = "instance"

#auto scaling group variables
desired_capacity = 2
max_size         = 3
min_size         = 1