# definition policies
resource "aws_iam_policy" "ecs-task-execution-policy" {
  policy = jsondecode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogStream",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:CreateLogGroup",
          "logs:PutLogEvents",
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_policy" "ecs-task-policy" {
  policy = jsondecode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

# definition policies attachment
resource "aws_iam_policy_attachment" "ecs-task-execution-attachment" {
  name       = "ecs-task-execution-attachment"
  policy_arn = aws_iam_policy.ecs-task-execution-policy.arn
  roles = [var.task-execution-role-name]
}

resource "aws_iam_policy_attachment" "ecs-task-attachment" {
  name       = "ecs-task-execution-attachment"
  policy_arn = aws_iam_policy.ecs-task-policy.arn
  roles = [var.task-role-name]
}