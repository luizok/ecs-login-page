resource "aws_lb" "alb" {
  name                       = "${var.project_name}-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.public_alb_sg.id]
  subnets                    = data.aws_subnets.subnets.ids
  enable_deletion_protection = false
}

resource "aws_lb_target_group" "alb_tg" {
  name     = "${var.project_name}-fargate-tg"
  port     = var.container_port
  protocol = "HTTP"
  vpc_id   = aws_default_vpc.default.id
  target_type = "ip"
  health_check {
    path                = "/health"
    protocol            = "HTTP"
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
  }

  load_balancing_algorithm_type = "least_outstanding_requests"

  stickiness {
    type = "app_cookie"
    cookie_name = "sessionId"
    enabled = true
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
  # default_action {
  #   type = "fixed-response"

  #   fixed_response {
  #     content_type = "text/plain"
  #     message_body = "Fixed response content"
  #     status_code  = "200"
  #   }
  # }
}
