# data "archive_file" "add-user" {
#  source_file = "lambdas/add-user.js"
#  output_path = "lambdas/add-user.zip"
#  type = "zip"
# }

# resource "aws_lambda_function" "add-user" {
#  environment {
#    variables = {
#      USER_TABLE = aws_dynamodb_table.user_table.name
#    }
#  }
#  memory_size = "128"
#  timeout = 10
#  runtime = "nodejs14.x"
#  architectures = ["arm64"]
#  handler = "lambdas/add-user.handler"
#  function_name = "add-user"
#  role = aws_iam_role.iam_for_lambda.arn
#  filename = "lambdas/add-user.zip"
# }

# data "archive_file" "get-user-by-cpf-or-email-archive" {
#  source_file = "lambdas/get-user-by-cpf-or-email.js"
#  output_path = "lambdas/get-user-by-cpf-or-email.zip"
#  type = "zip"
# }


# resource "aws_lambda_function" "get-user-by-cpf-or-email" {
#  environment {
#    variables = {
#      USER_TABLE = aws_dynamodb_table.user_table.name
#    }
#  }
#  memory_size = "128"
#  timeout = 10
#  runtime = "nodejs14.x"
#  architectures = ["arm64"]
#  handler = "lambdas/get-user-by-cpf-or-email.handler"
#  function_name = "get-user-by-cpf-or-email"
#  role = aws_iam_role.iam_for_lambda.arn
#  filename = "lambdas/get-user-by-cpf-or-email.zip"
# }

# data "archive_file" "get-all-users-archive" {
#  source_file = "lambdas/get-all-users.js"
#  output_path = "lambdas/get-all-users.zip"
#  type = "zip"
# }


# resource "aws_lambda_function" "get-all-users" {
#  environment {
#    variables = {
#      USER_TABLE = aws_dynamodb_table.user_table.name
#    }
#  }
#  memory_size = "128"
#  timeout = 10
#  runtime = "nodejs14.x"
#  architectures = ["arm64"]
#  handler = "lambdas/get-all-users.handler"
#  function_name = "get-all-users"
#  role = aws_iam_role.iam_for_lambda.arn
#  filename = "lambdas/get-all-users.zip"
# }
