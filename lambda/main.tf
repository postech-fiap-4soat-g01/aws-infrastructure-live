# data "archive_file" "add-user" {
#  source_file = "lambdas/create-note.js"
#  output_path = "lambdas/create-note.zip"
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
#  handler = "lambdas/create-note.handler"
#  function_name = "create-note"
#  role = aws_iam_role.iam_for_lambda.arn
#  filename = "lambdas/create-note.zip"
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
