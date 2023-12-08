variable env {
  type = string
  description = "env"
}

variable vpc_id {
  type = string
  description = "vpc id"
}

variable aws_region {
  type = string
  description = "the region will launch app"
}

variable tags {
  type = map(string)
  description = "List of tags"
}

variable vpc_endpoint_sg_ids {
  type = list(string)
  description = "List of vpc_endpoint_sg_ids"
}

variable vpc_endpoint_subnet_ids {
  type = list(string)
  description = "List of vpc_endpoint_subnet_ids"
}