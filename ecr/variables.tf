variable "ecr_name" {
  description = "The name of the ECR registry"
  type        = any
  default     = "ecr-fiap_4soat"
}

variable "image_mutability" {
  description = "Provide image mutability"
  type        = string
  default     = "IMMUTABLE"
}


variable "encrypt_type" {
  description = "Provide type of encryption here"
  type        = string
  default     = "KMS"
}

variable "tags" {
  description = "The key-value maps for tagging"
  type        = map(string)
  default     = {}
}