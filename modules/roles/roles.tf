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

data "aws_iam_policy_document" "jenkins-assume-role" {
  statement {
    sid     = "AllowEc2AssumeRole"
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
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

resource "aws_iam_role" "jenkins-instance-role" {
  name               = "jenkins-instance-role"
  assume_role_policy = data.aws_iam_policy_document.jenkins-assume-role.json
  tags               = merge({Name = "${var.env}-jenkins-instance-role"}, var.tags)
}

resource "aws_iam_instance_profile" "jenkins-instance-profile" {
  name = "jenkins-instance-profile"
  role = aws_iam_role.jenkins-instance-role.name
}

#resource "aws_iam_role" "ecs-service-role" {
#  assume_role_policy = ""
#}

output "ecs-task-execution-role" {
  value       = aws_iam_role.ecs-task-execution-role
  description = "ecs task execution role"
}

output "ecs-task-role" {
  value       = aws_iam_role.ecs-task-role
  description = "ecs task role"
}

output "jenkins-instance-role" {
  value       = aws_iam_role.jenkins-instance-role
  description = "jenkins instance role"
}

output "jenkins-instance-profile-name" {
  value       = aws_iam_instance_profile.jenkins-instance-profile.name
  description = "jenkins instance role name"
}