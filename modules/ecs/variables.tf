variable aws_region {
  type = string
  description = "the region will launch app"
}

variable env {
  type = string
  description = "environment name"
}

variable task-execution-role-arn {
  type = string
  description = "ecs-task-execution-role-arn"
}

variable task-role-arn {
  type = string
  description = "ecs-task-role-arn"
}

variable repository-url {
  type = string
  description = "the repository url of ECR"
}

variable tags {
  type = map(string)
}

# subnets will be placed fargate
variable private-subnet-ids {
  type = list(string)
}

# private security groups
variable private-sg-ids {
  type = list(string)
}

variable target-group-arn {
  type = string
}

variable logs-retention-in-days {
  type        = number
  default     = 1
  description = "Specifies the number of days you want to retain log events"
}

variable express-service-count {
  type        = number
  default     = 0
  description = "by default we won't provision service. We need provision and push image to ECR first"
}