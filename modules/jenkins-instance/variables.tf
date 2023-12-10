variable user-data {}
variable public-key {}
variable ubuntu-ami {
  type = string
}

variable public-subnet-id {
  type = string
}

variable jenkins-securitygroup-ids {
  type = list(string)
}

variable instance-device-name {
  type = string
}

variable availability-zone {
  type = string
}

variable jenkins-in-profile-name {
  type = string
  description = "jenkins instance profile name"
}