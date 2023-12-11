output "ecs-task-execution-role" {
  value       = aws_iam_role.ecs-task-execution-role
  description = "ecs task execution role"
}

output "ecs-task-role" {
  value       = aws_iam_role.ecs-task-role
  description = "ecs task role"
}