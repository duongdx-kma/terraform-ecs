# trusted policy
data "aws_iam_policy_document" "ecs-task-assume-role" {
  statement {
    sid     = "AllowEcsTaskAssumeRole"
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}
data "aws_iam_policy_document" "ecs-task-exec-assume-role" {
  statement {
    sid     = "AllowEcsTaskExecutionAssumeRole"
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# role
resource "aws_iam_role" "ecs-task-execution-role" {
  name               = "ecs-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs-task-exec-assume-role.json
  tags               = merge({Name = "${var.env}-ecs-task-execution-role"}, var.tags)
}

resource "aws_iam_role" "ecs-task-role" {
  name               = "ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs-task-assume-role.json
  tags               = merge({Name = "${var.env}-ecs-task-role"}, var.tags)
}

#resource "aws_iam_role" "ecs-service-role" {
#  assume_role_policy = ""
#}