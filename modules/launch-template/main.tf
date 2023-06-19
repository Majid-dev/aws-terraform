data "aws_ami" "demo_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_launch_template" "template" {
  name_prefix   = "launch_template"
  image_id      = data.aws_ami.demo_ami.id
  instance_type = var.instance_type
  user_data = filebase64(var.user_data_file)
  #vpc_security_group_ids = var.vpc_security_group_ids

  network_interfaces {
    subnet_id = var.subnet_id
    security_groups = var.vpc_security_group_ids
  }
 
}