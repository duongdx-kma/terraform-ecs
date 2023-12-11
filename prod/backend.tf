terraform {
  backend "s3" {
    bucket = "duongdx-terraform-state"
    key    = "terraform.tfstate"
    region = "ap-southeast-1"
  }
}