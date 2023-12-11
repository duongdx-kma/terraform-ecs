output "ecs_cluster_name" {
  value = aws_ecs_cluster.terraform-cluster.name
}

output "ecs_service_name" {
  value = aws_ecs_service.express-service.name
}