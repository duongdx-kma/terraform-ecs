resource "aws_vpc_endpoint" "s3-gateway-endpoint" {
  service_name       = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type  = "Gateway"
  route_table_ids    = var.vpc-private-route-table-id
  vpc_id             = var.vpc_id

  tags = merge({Name = "${var.env}-s3-gateway-endpoint"}, var.tags)
}

resource "aws_vpc_endpoint" "ecr-docker-interface-endpoint" {
  service_name        = "com.amazonaws.${var.aws_region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = var.vpc_endpoint_sg_ids
  subnet_ids          = var.vpc_endpoint_subnet_ids
  vpc_id              = var.vpc_id
  private_dns_enabled = true

  tags = merge({Name = "${var.env}-ecr-dkr-endpoint"}, var.tags)
}

resource "aws_vpc_endpoint" "ecr-api-interface-endpoint" {
  service_name        = "com.amazonaws.${var.aws_region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = var.vpc_endpoint_sg_ids
  subnet_ids          = var.vpc_endpoint_subnet_ids
  vpc_id              = var.vpc_id
  private_dns_enabled = true

  tags = merge({Name = "${var.env}-ecr-api-endpoint"}, var.tags)
}

resource "aws_vpc_endpoint" "logs-interface-endpoint" {
  service_name        = "com.amazonaws.${var.aws_region}.logs"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = var.vpc_endpoint_sg_ids
  subnet_ids          = var.vpc_endpoint_subnet_ids
  vpc_id              = var.vpc_id
  private_dns_enabled = true

  tags = merge({Name = "${var.env}-logs-endpoint"}, var.tags)
}
