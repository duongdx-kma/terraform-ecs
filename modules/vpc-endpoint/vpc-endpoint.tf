resource "aws_vpc_endpoint" "s3-gateway-endpoint" {
  service_name       = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type  = "Gateway"
  route_table_ids    = var.vpc-private-route-table-id
  vpc_id             = var.vpc_id
}

resource "aws_vpc_endpoint" "ecr-docker-interface-endpoint" {
  service_name       = "com.amazonaws.${var.aws_region}.ecr.dkr"
  vpc_endpoint_type  = "Interface"
  security_group_ids = var.vpc_endpoint_sg_ids
  subnet_ids         = var.vpc_endpoint_subnet_ids
  vpc_id             = var.vpc_id
}

resource "aws_vpc_endpoint" "ecr-api-interface-endpoint" {
  service_name       = "com.amazonaws.${var.aws_region}.ecr.api"
  vpc_endpoint_type  = "Interface"
  security_group_ids = var.vpc_endpoint_sg_ids
  subnet_ids         = var.vpc_endpoint_subnet_ids
  vpc_id             = var.vpc_id
}

resource "aws_vpc_endpoint" "logs-interface-endpoint" {
  service_name       = "com.amazonaws.${var.aws_region}.logs"
  vpc_endpoint_type  = "Interface"
  security_group_ids = var.vpc_endpoint_sg_ids
  subnet_ids         = var.vpc_endpoint_subnet_ids
  vpc_id             = var.vpc_id
}

output "s3-gateway-endpoint-id" {
  value = aws_vpc_endpoint.s3-gateway-endpoint.id
  description = "s3 gateway endpoint id"
}

output "ecr-docker-interface-endpoint" {
  value = aws_vpc_endpoint.ecr-docker-interface-endpoint.id
  description = "ecr.docker interface endpoint id"
}

output "ecr-api-interface-endpoint" {
  value = aws_vpc_endpoint.ecr-api-interface-endpoint.id
  description = "ecr.api interface endpoint id"
}

output "logs-interface-endpoint" {
  value = aws_vpc_endpoint.logs-interface-endpoint.id
  description = "logs interface endpoint id"
}
