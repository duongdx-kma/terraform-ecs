terraform {
  backend "s3" {
    bucket = "duongdx-terraform-state"
    key    = "terraform-prod.tfstate"
    region = "ap-southeast-1"
  }
}