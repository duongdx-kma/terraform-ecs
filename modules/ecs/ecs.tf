# ECS - cluster
resource "aws_ecs_cluster" "terraform-cluster" {
  name               = "terraform-cluster"
  capacity_providers = ["FARGATE"]

  tags = merge({Name = "${var.env}-terraform-cluster"}, var.tags)
}

# ECS - Service
resource "aws_ecs_service" "express-service" {
  name             = "express-dev"
  desired_count    = 1
  launch_type      = "FARGATE"
  platform_version = "1.4.0"
  cluster          = aws_ecs_cluster.terraform-cluster.id
  task_definition  = aws_ecs_task_definition.terraform-task-definition.arn

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }
  network_configuration {
    subnets = var.private-subnet-ids
    security_groups = var.private-sg-ids
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target-group-arn
    container_name   = "express-app"
    container_port   = 8088
  }
}

# ECS - task definition
resource "aws_ecs_task_definition" "terraform-task-definition" {
  family                   = "service"
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = var.task-execution-role-arn # role arn starting task
  task_role_arn            = var.task-role-arn # role arn for task's Application running
  requires_compatibilities = ["FARGATE"]
  container_definitions = jsonencode([
    {
      name      = "express-app"
      image     = "${var.repository-url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 80
        }
      ]
    }
  ])

  tags = merge({Name = "${var.env}-terraform-task-definition"}, var.tags)
}

output "ecs_cluster" {
  value = aws_ecs_cluster.terraform-cluster
}

output "ecs_service" {
  value = aws_ecs_service.express-service
}