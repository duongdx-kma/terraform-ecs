variable env {
  type = string
  description = "env"
}

variable aws_region {
  type = string
  description = "the region will launch app"
}

variable tags {
  type = map(string)
}