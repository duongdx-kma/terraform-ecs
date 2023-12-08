# public security
resource "aws_security_group" "alb-sg" {
  vpc_id = var.vpc_id
  dynamic "ingress" {
    for_each = var.alb-ingress
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.from_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  tags = merge({Name = "${var.env}-alb-sg"}, var.tags)
}

# private security
resource "aws_security_group" "instance-sg" {
  vpc_id = var.vpc_id
  dynamic "ingress" {
    for_each = var.instance-ingress
    content {
      from_port       = ingress.value.from_port
      to_port         = ingress.value.from_port
      protocol        = ingress.value.protocol
      security_groups = ingress.value.security_groups
    }
  }
  tags = merge({Name = "${var.env}-instance-sg"}, var.tags)
}

# vpc-endpoint security
resource "aws_security_group" "endpoint-sg" {
  vpc_id = var.vpc_id
  dynamic "ingress" {
    for_each = var.endpoint-ingress
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.from_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  tags = merge({Name = "${var.env}-endpoint-sg"}, var.tags)
}