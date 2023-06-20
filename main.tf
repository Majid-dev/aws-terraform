module "vpc" {
  source                = "./modules/vpc"
  region                = var.region
  vpc_cidr_block        = var.vpc_cidr_block
  project_name          = var.project_name
  subnet_az1_cidr_block = var.subnet_az1_cidr_block
  subnet_az2_cidr_block = var.subnet_az2_cidr_block
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
  source                 = "./modules/launch-template"
  instance_type          = var.instance_type
  user_data_file         = var.user_data_file
  vpc_security_group_ids = [module.security-group.webserver-security-group_id]
  subnet_id = module.vpc.subnet_az1_id
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
  alb_subnet_ids         = [module.vpc.subnet_az1_id, module.vpc.subnet_az2_id]
  target_group_arn       = module.target_group.target_group_arn
}

module "asg" {
  source             = "./modules/asg"
  project_name       = var.project_name
  target_group_arn   = module.target_group.target_group_arn
  launch_template_id = module.launch-template.launch_template_id
  desired_capacity   = var.desired_capacity
  max_size           = var.max_size
  min_size           = var.min_size
}