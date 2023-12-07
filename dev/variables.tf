variable aws_region {
  type    = string
  default = "ap-southeast-1"
}

variable tags {
  type = map(string)
  default = {
    Terraform   = 'yes'
    Environment = 'dev'
    App         = "Duongdx-terraform-ecs"
  }
}