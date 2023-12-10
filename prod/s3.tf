#resource "aws_s3_bucket" "terraform-state" {
#  bucket = "duongdx-terraform-state-${var.aws_region}"
##  force_destroy = true
#
#  tags = {
#    Name = "Terraform state"
#  }
#}