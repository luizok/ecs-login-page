resource "aws_dynamodb_table" "table" {
  name           = "${var.project_name}-Session-Table-${local.account_id}-${local.region}"
  billing_mode   = "PROVISIONED"
  read_capacity  = 2
  write_capacity = 2
  hash_key       = "sessionId"

  attribute {
    name = "sessionId"
    type = "S"
  }

  ttl {
    attribute_name = "expires"
    enabled        = true
  }
}
