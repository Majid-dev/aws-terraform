#environment variables
region       = "us-east-1"
project_name = "jupiter"
environment  = "production"

#VPC variables

vpc_cidr                     = "10.0.0.0/16"
public_subnet_az1_cidr       = "10.0.1.0/24"
public_subnet_az2_cidr       = "10.0.2.0/24"
private_app_subnet_az1_cidr  = "10.0.3.0/24"
private_app_subnet_az2_cidr  = "10.0.4.0/24"
private_data_subnet_az1_cidr = "10.0.5.0/24"
private_data_subnet_az2_cidr = "10.0.6.0/24"

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
desired_capacity = 1
max_size         = 2
min_size         = 1

#Relational Database Service variables
db_instance_identifier = "my-rds-instance"
db_name                = "my_database"
db_username            = "admin"
db_password            = "password123"
allocated_storage      = 20
instance_class         = "db.t2.micro"
create_read_replica    = true # Set this to false if you don't want to create a read replica