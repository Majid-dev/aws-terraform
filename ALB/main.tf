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
  subnet_id              = aws_default_subnet.sub_az_1a.id
  tags = {
    Name = each.value
  }
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_default_subnet" "sub_az_1a" {
  availability_zone = var.az_1a

  tags = {
    Name = "Default subnet for us-east-1a"
  }
}

resource "aws_default_subnet" "sub_az_1b" {
  availability_zone = var.az_1b

  tags = {
    Name = "Default subnet for us-east-1b"
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
    security_groups = [aws_security_group.sg_lb.id]
  }

  tags = {
    Name = "allow_http"
  }
}

resource "aws_security_group" "sg_lb" {
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

resource "aws_lb" "alb" {
  name               = "test-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_lb.id]
  subnets            = [aws_default_subnet.sub_az_1a.id, aws_default_subnet.sub_az_1b.id]

  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group_1.arn
  }
}


resource "aws_lb_listener_rule" "listener_rul_1" {
  listener_arn = aws_lb_listener.listener.arn
  priority     = 101

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group_2.arn
  }

  condition {
    path_pattern {
      values = ["/test"]
    }
  }
}

resource "aws_lb_listener_rule" "listener_rul_2" {
  listener_arn = aws_lb_listener.listener.arn
  priority     = 102

  action {
    type             = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Constant error response"
      status_code  = "404"
    }
  }

  condition {
    path_pattern {
      values = ["/constant"]
    }
  }
}

resource "aws_lb_target_group" "target_group_1" {
  name        = "lb-tg-1"
  port        = 80
  protocol    = "HTTP"
  protocol_version = "HTTP1"
  target_type = "instance"
  vpc_id      = aws_default_vpc.default.id

  health_check {
    path                = "/"
    port                = 80
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-499"
  }
}

resource "aws_lb_target_group" "target_group_2" {
  name        = "lb-tg-2"
  port        = 80
  protocol    = "HTTP"
  protocol_version = "HTTP1"
  target_type = "instance"
  vpc_id      = aws_default_vpc.default.id

  health_check {
    path                = "/"
    port                = 80
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-499"
  }
}

resource "aws_lb_target_group_attachment" "tg_attach_1" {
  for_each         = toset(slice(var.instance_list, 0,2))
  target_group_arn = aws_lb_target_group.target_group_1.arn
  target_id        = aws_instance.web[each.value].id
  port             = 80
}

resource "aws_lb_target_group_attachment" "tg_attach_2" {
  target_group_arn = aws_lb_target_group.target_group_2.arn
  target_id        = aws_instance.web[var.instance_list[2]].id
  port             = 80
}