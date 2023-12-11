# ECS - cluster
resource "aws_ecs_cluster" "terraform-cluster" {
  name               = "terraform-cluster"
  tags = merge({Name = "${var.env}-terraform-cluster"}, var.tags)
}

resource "aws_ecs_cluster_capacity_providers" "example" {
  cluster_name = aws_ecs_cluster.terraform-cluster.name
  capacity_providers = ["FARGATE"]
}

# ECS - Service
resource "aws_ecs_service" "express-service" {
  count            = var.express-service-count
  name             = "express-${var.env}"
  desired_count    = 1
  launch_type      = "FARGATE"
  platform_version = "1.4.0"
  cluster          = aws_ecs_cluster.terraform-cluster.id
  task_definition  = aws_ecs_task_definition.terraform-task-definition.arn

  lifecycle {
    ignore_changes = [desired_count]
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
      image     = var.repository-url
      essential = true
      portMappings = [
        {
          containerPort = 8088
          hostPort      = 8088
        }
      ],
      logConfiguration: {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/fargate/service/express-${var.env}",
          "awslogs-region": var.aws_region,
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ])

  tags = merge({Name = "${var.env}-terraform-task-definition"}, var.tags)
}

resource "aws_cloudwatch_log_group" "logs" {
  name              = "/fargate/service/express-${var.env}"
  retention_in_days = var.logs-retention-in-days
  tags              = var.tags
}