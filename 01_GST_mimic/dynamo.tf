# DynamoDB Table
resource "aws_dynamodb_table" "mimic_table" {
  name           = "${var.table_name}-${random_id.suffix.hex}"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name = "MimicTable"
  }
}