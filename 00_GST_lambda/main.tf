# Crear archivo ZIP con el código compilado
data "external" "build_lambda" {
  program = ["bash", "-c", "cd src && env GOOS=linux GOARCH=arm64 go build -o bootstrap main.go && echo '{\"filename\":\"bootstrap\"}'"]
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/src/bootstrap"
  output_path = "${path.module}/lambda_function.zip"
  depends_on  = [data.external.build_lambda]
}

# Rol IAM para Lambda
resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"

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

# Política básica para Lambda
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role.name
}

# Función Lambda
resource "aws_lambda_function" "go_lambda" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "go-hello-serverless-lambda"
  role             = aws_iam_role.lambda_role.arn
  handler          = "main"
  runtime          = "provided.al2023"
  architectures    = ["arm64"]
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  depends_on = [
    aws_iam_role_policy_attachment.lambda_basic,
    data.archive_file.lambda_zip
  ]
}

