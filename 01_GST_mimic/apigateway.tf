# API Gateway
resource "aws_api_gateway_rest_api" "mimic_api" {
  name        = "${var.api_name}-${random_id.suffix.hex}"
  description = "Mimic API for storing and retrieving JSON data"
}

# API Gateway Resource (root)
resource "aws_api_gateway_resource" "mimic_resource" {
  rest_api_id = aws_api_gateway_rest_api.mimic_api.id
  parent_id   = aws_api_gateway_rest_api.mimic_api.root_resource_id
  path_part   = "mimic"
}

# API Gateway Resource with ID parameter
resource "aws_api_gateway_resource" "mimic_id_resource" {
  rest_api_id = aws_api_gateway_rest_api.mimic_api.id
  parent_id   = aws_api_gateway_resource.mimic_resource.id
  path_part   = "{id}"
}

# POST Method
resource "aws_api_gateway_method" "mimic_post" {
  rest_api_id   = aws_api_gateway_rest_api.mimic_api.id
  resource_id   = aws_api_gateway_resource.mimic_resource.id
  http_method   = "POST"
  authorization = "NONE"
  api_key_required = true
}

# GET Method
resource "aws_api_gateway_method" "mimic_get" {
  rest_api_id   = aws_api_gateway_rest_api.mimic_api.id
  resource_id   = aws_api_gateway_resource.mimic_id_resource.id
  http_method   = "GET"
  authorization = "NONE"
  api_key_required = true
}

# Lambda Integration for POST (CREATE)
resource "aws_api_gateway_integration" "mimic_post_integration" {
  rest_api_id = aws_api_gateway_rest_api.mimic_api.id
  resource_id = aws_api_gateway_resource.mimic_resource.id
  http_method = aws_api_gateway_method.mimic_post.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.mimic_create_lambda.invoke_arn
}

# Lambda Integration for GET
resource "aws_api_gateway_integration" "mimic_get_integration" {
  rest_api_id = aws_api_gateway_rest_api.mimic_api.id
  resource_id = aws_api_gateway_resource.mimic_id_resource.id
  http_method = aws_api_gateway_method.mimic_get.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.mimic_get_lambda.invoke_arn
}

# Lambda Permission for API Gateway POST (CREATE)
resource "aws_lambda_permission" "api_gateway_post" {
  statement_id  = "AllowExecutionFromAPIGatewayPost"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.mimic_create_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.mimic_api.execution_arn}/*/*"
}

# Lambda Permission for API Gateway GET
resource "aws_lambda_permission" "api_gateway_get" {
  statement_id  = "AllowExecutionFromAPIGatewayGet"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.mimic_get_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.mimic_api.execution_arn}/*/*"
}

# API Gateway Deployment
resource "aws_api_gateway_deployment" "mimic_deployment" {
  depends_on = [
    aws_api_gateway_integration.mimic_post_integration,
    aws_api_gateway_integration.mimic_get_integration
  ]

  rest_api_id = aws_api_gateway_rest_api.mimic_api.id
}

# API Gateway Stage
resource "aws_api_gateway_stage" "mimic_stage" {
  deployment_id = aws_api_gateway_deployment.mimic_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.mimic_api.id
  stage_name    = var.api_stage
}

# API Key
resource "aws_api_gateway_api_key" "mimic_api_key" {
  name = "${var.api_name}-key-${random_id.suffix.hex}"
  description = "API Key for Mimic API"
}

# Usage Plan
resource "aws_api_gateway_usage_plan" "mimic_usage_plan" {
  name         = "${var.api_name}-usage-plan-${random_id.suffix.hex}"
  description  = "Usage plan for Mimic API"

  api_stages {
    api_id = aws_api_gateway_rest_api.mimic_api.id
    stage  = aws_api_gateway_stage.mimic_stage.stage_name
  }

  quota_settings {
    limit  = var.api_quota_limit
    period = "MONTH"
  }

  throttle_settings {
    rate_limit  = var.api_rate_limit
    burst_limit = var.api_burst_limit
  }
}

# Usage Plan Key
resource "aws_api_gateway_usage_plan_key" "mimic_usage_plan_key" {
  key_id        = aws_api_gateway_api_key.mimic_api_key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.mimic_usage_plan.id
}