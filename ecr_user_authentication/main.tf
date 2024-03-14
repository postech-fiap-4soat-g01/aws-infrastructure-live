resource "aws_ecr_repository" "fast_food_user_management" {
  name = var.ecr_name
  image_tag_mutability = var.image_mutability
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "null_resource" "push_image" {
  depends_on = [aws_ecr_repository.fast_food_user_management]

  provisioner "local-exec" {
    command = "docker pull alpine && docker tag alpine:latest ${aws_ecr_repository.fast_food_user_management.repository_url}:latest && aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${aws_ecr_repository.fast_food_user_management.repository_url} && docker push ${aws_ecr_repository.fast_food_user_management.repository_url}:latest"
  }
}

output "lambda_image" {
  value = "${aws_ecr_repository.fast_food_user_management.repository_url}:latest"
}