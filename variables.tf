variable "region" {
  type    = string
  default = "us-east-1"
}

variable "create_lambda" {
  type    = bool
  default = true
}

variable "integration_uri_lb" {
  type    = string
  default = "http://aa7ba84dc748d40faa8765f95f8625f4-153419404.us-east-1.elb.amazonaws.com"
}