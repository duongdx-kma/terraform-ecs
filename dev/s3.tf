resource "aws_s3_bucket" "terraform-state" {
  bucket = "duongdx-terraform-state"
  force_destroy = true

  tags = {
    Name = "Terraform state"
  }
}