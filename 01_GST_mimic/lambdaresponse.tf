# Build GET Lambda
data "external" "build_get_lambda" {
  program = ["bash", "-c", "cd src/response && go mod tidy && env GOOS=linux GOARCH=arm64 go build -o bootstrap main.go && echo '{\"filename\":\"bootstrap\"}'"]
}

data "archive_file" "get_lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/src/response/bootstrap"
  output_path = "${path.module}/get_lambda_function.zip"
  depends_on  = [data.external.build_get_lambda]
}

# GET Lambda Function
resource "aws_lambda_function" "mimic_get_lambda" {
  filename         = data.archive_file.get_lambda_zip.output_path
  function_name    = "${var.function_name}-get-${random_id.suffix.hex}"
  role             = aws_iam_role.lambda_role.arn
  handler          = var.handler
  runtime          = var.runtime
  architectures    = [var.architecture]
  timeout          = var.timeout
  memory_size      = var.memory_size
  source_code_hash = data.archive_file.get_lambda_zip.output_base64sha256

  environment {
    variables = {
      MIMIC_TABLE = aws_dynamodb_table.mimic_table.name
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_basic,
    aws_iam_role_policy.lambda_dynamodb,
    data.archive_file.get_lambda_zip
  ]
}