# ECS - cluster
resource "aws_ecs_cluster" "terraform-cluster" {
  name = "terraform-cluster"
}

resource "aws_ecs_cluster_capacity_providers" "example" {
  cluster_name = aws_ecs_cluster.terraform-cluster.name
  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

# ECS - Service
resource "aws_ecs_service" "express-dev" {
  name            = "express-dev"
  cluster         = aws_ecs_cluster.terraform-cluster.id
  task_definition = aws_ecs_task_definition.terraform-task-definition.arn
  desired_count   = 3
  iam_role        = aws_iam_role.foo.arn
  depends_on      = [aws_iam_role_policy.foo]

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.foo.arn
    container_name   = "express-app"
    container_port   = 8088
  }
}

# ECS - task definition
resource "aws_ecs_task_definition" "terraform-task-definition" {
  family                    = "service"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn = "" # role starting task
  task_role_arn = "" # role for task's Application running

  container_definitions = jsonencode([
    {
      name      = "express-app"
      image     = "${aws_ecr_repository.my-ecr.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 80
        }
      ]
    }
  ])
#  volume {
#    name      = "service-storage"
#    host_path = "/ecs/service-storage"
#  }
}