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
  default = "http://ac6b7b0fb8db54e2da01a8caa2b85005-823164483.us-east-1.elb.amazonaws.com"
}

