output "ecs_cluster" {
  value = aws_ecs_cluster.terraform-cluster
}

output "ecs_service" {
  value = aws_ecs_service.express-service
}