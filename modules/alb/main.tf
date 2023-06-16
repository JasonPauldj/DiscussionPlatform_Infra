resource "aws_lb" "lb" {
  name               = "dp-lb"
  load_balancer_type = "application"
  subnets            = var.public-subnet-ids
  security_groups    = var.lb-sg-ids
}

resource "aws_lb_target_group" "tg" {
  name     = "dp-tg"
  port     = var.server-port
  protocol = "HTTP"
  vpc_id   = var.vpc-id
  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 30
    matcher             = 200
    path                = "/health"
    port                = var.server-port
    protocol            = "HTTP"
    timeout             = 6
    unhealthy_threshold = 3
  }
  target_type = "ip"
}

resource "aws_lb_listener" "lb-listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}