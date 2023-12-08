# define application load balancer
resource "aws_lb" "main-alb" {
  name               = "main-alb"
  internal           = false
  subnets            = [var.alb-public-subnet-ids]
  security_groups    = [var.alb-http-sg-id]
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
  target_type = "instance"

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
resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn = aws_lb.main-alb.arn
  port              = var.lb-listen-port
  protocol          = var.lb-listen-protocol
#  ssl_policy        = var.env == "prod" ? "ELBSecurityPolicy-2016-08" : ""
#  certificate_arn   = var.env == "prod" ? var.certificate_arn : ""

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-target-group.arn
  }
}

output "lb_dns" {
  value = aws_lb.main-alb.dns_name
}