data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


resource "aws_instance" "web" {
  for_each               = toset(var.instance_list)
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  user_data              = file(var.entry_script_file)
  vpc_security_group_ids = [aws_security_group.allow_http.id]

  tags = {
    Name = each.value
  }
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_default_subnet" "sub_az1" {
  availability_zone = var.default_az

  tags = {
    Name = "Default subnet for us-east-1a"
  }
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow http inbound traffic"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    description     = "http from VPC"
    from_port       = 80
    to_port         = 80
    protocol        = var.gp_protocol
    security_groups = [aws_security_group.sg_elb.id]
  }

  tags = {
    Name = "allow_http_ssh"
  }
}

resource "aws_security_group" "sg_elb" {
  name        = "sg_elb"
  description = "Allow http inbound traffic to load balancer"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = var.gp_protocol
    cidr_blocks = [var.cidr_blocks]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_blocks]
  }

  tags = {
    Name = "security_group_elb"
  }
}

resource "aws_elb" "bar" {
  name               = "foobar-terraform-elb"
  availability_zones = [var.default_az]
  security_groups    = [aws_security_group.sg_elb.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 4
    target              = "HTTP:80/"
    interval            = 5
  }

  instances                   = [for index in var.instance_list : aws_instance.web[index].id]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "foobar-terraform-elb"
  }
}