variable env {
  type    = string
  default = "dev"
}

variable aws_region {
  type    = string
  default = "ap-southeast-1"
}

variable tags {
  type = map(string)
  default = {
    Terraform   = "yes"
    Environment = "dev"
    App         = "Duongdx-terraform-ecs"
  }
}

# load balancer listen port
variable lb-listen-port {
  type = number
  default = 80
}

# load balancer listen protocol
variable lb-listen-protocol {
  type = string
  default = "HTTP"
}

# load balancer listen port
variable instance-port {
  type = number
  default = 8088
}
