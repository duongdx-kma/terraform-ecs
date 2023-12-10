resource "aws_ecr_repository" "express-ecr" {
  name         = "express-ecr"
  force_delete = true
}

output "ecr-output" {
  value = aws_ecr_repository.express-ecr.repository_url
}