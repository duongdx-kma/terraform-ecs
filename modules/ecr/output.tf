output "ecr-output" {
  value = aws_ecr_repository.my-ecr.repository_url
}