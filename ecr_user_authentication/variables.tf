variable "ecr_name" {
  description = "The name of the ECR registry"
  type        = any
  default     = "fast_food_user_management"
}

variable "image_mutability" {
  description = "Provide image mutability"
  type        = string
  default     = "MUTABLE"
}
