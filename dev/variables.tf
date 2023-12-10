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

variable express-service-count {
  type = number
  default = 0
  description = "by default we won't provision service. We need provision and push image to ECR first"
}

variable auto-scaling-count {
  type        = number
  default     = 0
  description = "by default we won't provision auto scaling. We need provision and push image to ECR first"
}

variable jenkins-version {
  type = string
  default = "2.414.3"
  description = "jenkins-version"
}

variable instance-device-name {
  default = "/dev/xvdh"
}

variable terraform-version {
  default = "1.6.5"
}

variable path-to-public-key {
  default = "my-key.pub"
}

variable ubuntu-ami {
  default = "ami-078c1149d8ad719a7"
}

variable commit-id {
  default = ""
}
