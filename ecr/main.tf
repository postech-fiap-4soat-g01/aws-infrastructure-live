resource "aws_ecr_repository" "ecr_totem" {
  name                 = var.ecr_totem_name
  image_tag_mutability = var.image_mutability
  
  encryption_configuration {
    encryption_type = var.encrypt_type
  }

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}


resource "aws_ecr_repository" "ecr_user" {
  name = var.ecr_user_name

  image_tag_mutability = var.image_mutability
  
  encryption_configuration {
    encryption_type = var.encrypt_type
  }

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

resource "null_resource" "push_image" {
  depends_on = [aws_ecr_repository.ecr_user]

  provisioner "local-exec" {
    command = "docker pull alpine && docker tag alpine:latest ${aws_ecr_repository.ecr_user.repository_url}:latest && aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${aws_ecr_repository.ecr_user.repository_url} && docker push ${aws_ecr_repository.ecr_user.repository_url}:latest"
  }
}

output "lambda_image" {
  value = "${aws_ecr_repository.ecr_user.repository_url}:latest"
}