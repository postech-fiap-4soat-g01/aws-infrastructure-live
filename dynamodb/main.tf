resource "aws_dynamodb_table" "user_table" {
 name = "FastFoodUserManagement"
 billing_mode = "PAY_PER_REQUEST"
 
 attribute {
  name = "pk"
  type = "S"
 }

 attribute {
  name = "sk"
  type = "S"
 }

 attribute {
  name = "name"
  type = "S"
 }

 attribute {
  name = "email"
  type = "S"
 }

 attribute {
  name = "identification"
  type = "S"
 }

 attribute {
  name = "cognitoUserIdentification"
  type = "S"
 }

 hash_key = "pk"
}