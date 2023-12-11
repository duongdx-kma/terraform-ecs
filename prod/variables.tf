variable env {
  type    = string
  default = "prod"
}

variable aws_region {
  type    = string
  default = "ap-southeast-1"
}

variable tags {
  type = map(string)
  default = {
    Terraform   = "yes"
    Environment = "prod"
    App         = "Duongdx-terraform-ecs"
  }
}

# load balancer listen port
variable lb-listen-port {
  type = number
  default = 443
}

# load balancer listen protocol
variable lb-listen-protocol {
  type = string
  default = "HTTPS"
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

variable instance-type {
  default = "t2.medium"
}

variable terraform-version {
  default = "1.6.5"
}

variable path-to-public-key {
  default = "my-key.pub"
}

variable ubuntu-ami {
  type = map(string)
  default = {
    "ap-southeast-1": "ami-078c1149d8ad719a7"
  }
}

variable commit-id {
  default = ""
}

variable "root_domain_name" {
  type    = string
  default = "duongdx.com"
}

variable "hosted_zone_id" {
  type    = string
  default = "Z10021163CFESZLAG77PX"
}