output "create_lambda_function_name" {
  description = "Name of the CREATE Lambda function"
  value       = aws_lambda_function.mimic_create_lambda.function_name
}

output "create_lambda_function_arn" {
  description = "ARN of the CREATE Lambda function"
  value       = aws_lambda_function.mimic_create_lambda.arn
}

output "get_lambda_function_name" {
  description = "Name of the GET Lambda function"
  value       = aws_lambda_function.mimic_get_lambda.function_name
}

output "get_lambda_function_arn" {
  description = "ARN of the GET Lambda function"
  value       = aws_lambda_function.mimic_get_lambda.arn
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  value       = aws_dynamodb_table.mimic_table.name
}

output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table"
  value       = aws_dynamodb_table.mimic_table.arn
}

output "api_gateway_url" {
  description = "URL of the API Gateway"
  value       = "https://${aws_api_gateway_rest_api.mimic_api.id}.execute-api.${data.aws_region.current.id}.amazonaws.com/${var.api_stage}"
}

output "api_gateway_id" {
  description = "ID of the API Gateway"
  value       = aws_api_gateway_rest_api.mimic_api.id
}

output "api_key_id" {
  description = "ID of the API Key"
  value       = aws_api_gateway_api_key.mimic_api_key.id
}

output "api_key_value" {
  description = "Value of the API Key"
  value       = aws_api_gateway_api_key.mimic_api_key.value
  sensitive   = true
}

data "aws_region" "current" {}

output "resource_suffix" {
  description = "Random suffix used for resource names"
  value       = random_id.suffix.hex
}