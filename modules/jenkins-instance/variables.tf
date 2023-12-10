variable user-data {}
variable public-key {}
variable ubuntu-ami {
  type = string
}

variable instance-device-name {
  type = string
}

variable jenkins-ingress {
  type = list(object({
    from_port: number
    to_port: number
    protocol: string
    cidr_blocks: list(string)
  }))

  description = "jenkins ingress"
}