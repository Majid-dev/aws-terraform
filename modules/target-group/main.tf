resource "aws_lb_target_group" "target_group" {
  name        = "lb-tg-1"
  port        = var.tg_port
  protocol    = var.tg_protocol
  protocol_version = "HTTP1"
  target_type = var.tg_target_type
  vpc_id      = var.vpc_id

  health_check {
    path                = var.health_check_path
    port                = var.tg_port
    protocol            = var.tg_protocol
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-499"
  }
}