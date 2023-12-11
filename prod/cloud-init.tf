data "cloudinit_config" "cloudinit-jenkins" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    content      = templatefile("scripts/jenkins-init.sh", {
      DEVICE            = var.instance-device-name
#      JENKINS_VERSION   = var.jenkins-version
      TERRAFORM_VERSION = var.terraform-version
    })
  }
}