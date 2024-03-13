terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


resource "aws_iam_access_key" "fast_food_user_management_user_access" {
  user = aws_iam_user.fast_food_user_management_lambda_user.name
}

resource "aws_iam_user" "fast_food_user_management_lambda_user" {
  name = "fast_food_user_management_lambda_user"
  path = "/system/"
}

data "aws_iam_policy_document" "fast_food_user_management_lambda_user_policy" {
  statement {
    effect    = "Allow"
    actions   = ["*"]
    resources = ["*"]
  }
}

resource "aws_iam_user_policy" "fast_food_user_management_lambda_user_policy" {
  name   = "fast_food_user_management_lambda_user_policy"
  user   = aws_iam_user.fast_food_user_management_lambda_user.name
  policy = data.aws_iam_policy_document.fast_food_user_management_lambda_user_policy.json
}

output "secret" {
  value = aws_iam_access_key.fast_food_user_management_user_access.encrypted_secret
}