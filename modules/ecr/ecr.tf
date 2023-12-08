resource "aws_ecr_repository" "my-ecr" {
  name = "my-ecr"
}

output "ecr-output" {
  value = aws_ecr_repository.my-ecr.repository_url
}