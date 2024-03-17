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
  default = "http://a0b3fcd947f3648fd9551892b7d1771c-554626458.us-east-1.elb.amazonaws.com"
}