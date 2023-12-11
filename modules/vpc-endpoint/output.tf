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
