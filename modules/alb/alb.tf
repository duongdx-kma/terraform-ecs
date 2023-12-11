# define application load balancer
resource "aws_lb" "main-alb" {
  name               = "main-alb"
  internal           = false
  subnets            = var.alb-public-subnet-ids
  security_groups    = var.alb-sg-ids
  load_balancer_type = "application"

  tags = merge({Name = "${var.env}-main-alb"}, var.tags)
}


# Termination SSL/TLS
# define application load balancer - target-group
resource "aws_lb_target_group" "alb-target-group" {
  name        = "alb-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = var.health_check
    matcher             = var.health_check_matcher
    interval            = var.health_check_interval
    timeout             = var.health_check_timeout
    healthy_threshold   = var.health-check-count
    unhealthy_threshold = var.health-check-count
  }
}

# define application load balancer - listener
resource "aws_lb_listener" "alb-listener-https" {
  count             = var.lb-listen-port == 443 ? 1 : 0
  load_balancer_arn = aws_lb.main-alb.arn
  port              = var.lb-listen-port
  protocol          = var.lb-listen-protocol
  certificate_arn = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-target-group.arn
  }
}

resource "aws_lb_listener" "alb-listener-http" {
  count             = var.lb-listen-port == 80 ? 1 : 0
  load_balancer_arn = aws_lb.main-alb.arn
  port              = var.lb-listen-port
  protocol          = var.lb-listen-protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-target-group.arn
  }
}

resource "aws_lb_listener" "redirect" {
  count             = var.lb-listen-port == 443 ? 1 : 0
  load_balancer_arn = aws_lb.main-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
