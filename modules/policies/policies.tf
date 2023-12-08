data "aws_iam_policy_document" "ecs_service_elb" {
  statement {
    effect = "Allow"

    actions = [
      "ec2:Describe*"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "elasticloadbalancing:RegisterTargets"
    ]

    resources = [
      var.alb-arn
    ]
  }
}

data "aws_iam_policy_document" "ecs_service_standard" {

  statement {
    effect = "Allow"

    actions = [
      "ec2:DescribeTags",
      "ecs:DeregisterContainerInstance",
      "ecs:DiscoverPollEndpoint",
      "ecs:Poll",
      "ecs:RegisterContainerInstance",
      "ecs:StartTelemetrySession",
      "ecs:UpdateContainerInstancesState",
      "ecs:Submit*",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "*"
    ]
  }
}

data "aws_iam_policy_document" "ecs_service_scaling" {

  statement {
    effect = "Allow"

    actions = [
      "application-autoscaling:*",
      "ecs:DescribeServices",
      "ecs:UpdateService",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:PutMetricAlarm",
      "cloudwatch:DeleteAlarms",
      "cloudwatch:DescribeAlarmHistory",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:DescribeAlarmsForMetric",
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:ListMetrics",
      "cloudwatch:PutMetricAlarm",
      "cloudwatch:DisableAlarmActions",
      "cloudwatch:EnableAlarmActions",
      "iam:CreateServiceLinkedRole",
      "sns:CreateTopic",
      "sns:Subscribe",
      "sns:Get*",
      "sns:List*"
    ]

    resources = [
      "*"
    ]
  }
}

# definition policies
resource "aws_iam_policy" "ecs-task-execution-policy" {
  name = "ecs-task-execution-policy"
  path = "/"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Resource = "*"
        Action   = [
          "logs:CreateLogStream",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:CreateLogGroup",
          "logs:PutLogEvents",
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:*",
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "ecs_service_elb" {
  name = "ecs_service_elb"
  path = "/"
  description = "Allow access to the service elb"

  policy = data.aws_iam_policy_document.ecs_service_elb.json
}

resource "aws_iam_policy" "ecs_service_standard" {
  name = "ecs_service_standard"
  path = "/"
  description = "Allow standard ecs actions"

  policy = data.aws_iam_policy_document.ecs_service_standard.json
}

resource "aws_iam_policy" "ecs_service_scaling" {
  name = "ecs_service_scaling"
  path = "/"
  description = "Allow ecs service scaling"

  policy = data.aws_iam_policy_document.ecs_service_scaling.json
}

# definition policies attachment
resource "aws_iam_policy_attachment" "ecs-task-execution-attachment" {
  name       = "ecs-task-execution-attachment"
  policy_arn = aws_iam_policy.ecs-task-execution-policy.arn
  roles = [var.task-execution-role-name]
}

resource "aws_iam_role_policy_attachment" "ecs_service_elb" {
  role = var.task-role-name
  policy_arn = aws_iam_policy.ecs_service_elb.arn
}

resource "aws_iam_role_policy_attachment" "ecs_service_standard" {
  role = var.task-role-name
  policy_arn = aws_iam_policy.ecs_service_standard.arn
}

resource "aws_iam_role_policy_attachment" "ecs_service_scaling" {
  role = var.task-role-name
  policy_arn = aws_iam_policy.ecs_service_scaling.arn
}