module "vpc" {
  source                       = "./modules/vpc"
  region                       = var.region
  project_name                 = var.project_name
  environment                  = var.environment
  vpc_cidr                     = var.vpc_cidr
  public_subnet_az1_cidr       = var.public_subnet_az1_cidr
  public_subnet_az2_cidr       = var.public_subnet_az2_cidr
  private_app_subnet_az1_cidr  = var.private_app_subnet_az1_cidr
  private_app_subnet_az2_cidr  = var.private_app_subnet_az2_cidr
  private_data_subnet_az1_cidr = var.private_data_subnet_az1_cidr
  private_data_subnet_az2_cidr = var.private_data_subnet_az2_cidr
}

module "iam" {
  source            = "./modules/iam"
  group_name        = var.group_name
  user_name         = var.user_name
  group_policy_name = var.group_policy_name
  user_policy_name  = var.user_policy_name
}

module "security-group" {
  source = "./modules/security-group"
  vpc_id = module.vpc.vpc_id
}

module "launch-template" {
  source             = "./modules/launch-template"
  instance_type      = var.instance_type
  user_data_file     = var.user_data_file
  security_group_ids = [module.security-group.webserver-security-group_id]
}

module "target_group" {
  source            = "./modules/target-group"
  project_name      = var.project_name
  vpc_id            = module.vpc.vpc_id
  health_check_path = var.health_check_path
  tg_port           = var.tg_port
  tg_protocol       = var.tg_protocol
  tg_target_type    = var.tg_target_type
}

module "alb" {
  source                 = "./modules/alb"
  project_name           = var.project_name
  alb_security_group_ids = [module.security-group.alb-security-group_id]
  alb_subnet_ids         = [module.vpc.public_subnet_az1_id, module.vpc.public_subnet_az2_id]
  target_group_arn       = module.target_group.target_group_arn
}

module "asg" {
  source             = "./modules/asg"
  project_name       = var.project_name
  target_group_arn   = module.target_group.target_group_arn
  subnet_ids         = [module.vpc.private_app_subnet_az1_id, module.vpc.private_app_subnet_az2_id]
  launch_template_id = module.launch-template.launch_template_id
  desired_capacity   = var.desired_capacity
  max_size           = var.max_size
  min_size           = var.min_size
}

module "rds_with_replica" {
  source = "./modules/rds"

  db_instance_identifier = var.db_instance_identifier
  db_name                = var.db_name
  db_username            = var.db_username
  db_password            = var.db_password
  allocated_storage      = var.allocated_storage
  instance_class         = var.instance_class
  vpc_security_group_ids = [module.security-group.database-security-group_id]
  subnet_ids             = [module.vpc.private_data_subnet_az1_id, module.vpc.private_data_subnet_az2_id]
  create_read_replica    = true # Set this to false if you don't want to create a read replica
}