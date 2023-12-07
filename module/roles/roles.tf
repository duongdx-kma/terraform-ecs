resource "aws_iam_role" "ecs-task-execution-role" {
  assume_role_policy = ""
}

resource "aws_iam_role" "ecs-task-role" {
  assume_role_policy = ""
}

resource "aws_iam_role" "ecs-service-role" {
  assume_role_policy = ""
}