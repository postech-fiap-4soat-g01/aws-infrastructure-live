variable "region" {
  type    = string
  default = "us-east-1"
}

variable "create_lambda" {
  type    = bool
  default = false
}

variable "integration_uri_lb" {
  type    = string
  default = ""
}

