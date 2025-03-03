# DynamoDB Table for State Locking
resource "aws_dynamodb_table" "dynamodb_locking_table" {
  name         = "dynamodb-state-locking-table"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "LockID"
    type = "S"
  }
}