resource "aws_ecr_repository" "express-ecr" {
  name         = "express-ecr"
  force_delete = true
}
