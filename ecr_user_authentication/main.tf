resource "aws_ecr_repository" "fast_food_user_management" {
  name = var.ecr_name
  image_tag_mutability = var.image_mutability
  image_scanning_configuration {
    scan_on_push = true
  }
}
