resource "aws_dynamodb_table" "user_table" {
 name = "user"
 billing_mode = "PAY_PER_REQUEST"
 
 attribute {
  name = "pk"
  type = "S"
 }

 hash_key = "pk"
}