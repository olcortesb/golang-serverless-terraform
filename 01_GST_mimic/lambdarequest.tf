# Build CREATE Lambda
data "external" "build_create_lambda" {
  program = ["bash", "-c", "cd src/request && go mod tidy && env GOOS=linux GOARCH=arm64 go build -o bootstrap main.go && echo '{\"filename\":\"bootstrap\"}'"]
}

data "archive_file" "create_lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/src/request/bootstrap"
  output_path = "${path.module}/create_lambda_function.zip"
  depends_on  = [data.external.build_create_lambda]
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "${var.role_name}-${random_id.suffix.hex}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Basic Lambda policy
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role.name
}

# DynamoDB policy
resource "aws_iam_role_policy" "lambda_dynamodb" {
  name = "lambda_dynamodb_policy-${random_id.suffix.hex}"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem"
        ]
        Resource = aws_dynamodb_table.mimic_table.arn
      }
    ]
  })
}

# CREATE Lambda Function
resource "aws_lambda_function" "mimic_create_lambda" {
  filename         = data.archive_file.create_lambda_zip.output_path
  function_name    = "${var.function_name}-create-${random_id.suffix.hex}"
  role             = aws_iam_role.lambda_role.arn
  handler          = var.handler
  runtime          = var.runtime
  architectures    = [var.architecture]
  timeout          = var.timeout
  memory_size      = var.memory_size
  source_code_hash = data.archive_file.create_lambda_zip.output_base64sha256

  environment {
    variables = {
      MIMIC_TABLE = aws_dynamodb_table.mimic_table.name
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_basic,
    aws_iam_role_policy.lambda_dynamodb,
    data.archive_file.create_lambda_zip
  ]
}