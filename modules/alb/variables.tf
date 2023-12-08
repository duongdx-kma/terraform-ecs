# note that this creates the alb, target group, and access logs
# the listeners are defined in lb-http.tf and lb-https.tf
# delete either of these if your app doesn't need them
# but you need at least one

# Whether the application is available on the public internet,
# also will determine which subnets will be used (public or private)
variable internal {
  default = true
}

# The amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused
variable deregistration_delay {
  default = 30
}

# The path to the health check for the load balancer to know if the container(s) are ready
variable health_check {
  default = '/'
}

# How often to check the liveliness of the container
variable health_check_interval {
  default = 30
}

# How long to wait for the response on the health check path
variable health_check_timeout {
  default = 10
}

# What HTTP response code to listen for
variable health_check_matcher {
  default = 200
}

variable alb-http-sg-id {
  type = string
  description = "alb-http-sg-id"
}

variable env {
  type = string
  description = "environment name"
}

variable vpc_id {
  type = string
  description = "vpc_id"
}

variable alb-public-subnet-ids {
  type = list(string)
  description = "the public subnet for application load balancer"
}

variable tags {
  type = map(string)
  description = "List tags"
}

variable health-check-count {
  type = number
  default = 5
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

# load balancer listen protocol
variable certificate_arn {
  type = string
  default = ""
  description = "certificate arn"
}