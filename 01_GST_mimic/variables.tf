variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = "go-mimic-lambda"
}

variable "role_name" {
  description = "Name of the IAM role for Lambda execution"
  type        = string
  default     = "mimic_lambda_execution_role"
}

variable "runtime" {
  description = "Lambda runtime"
  type        = string
  default     = "provided.al2023"
}

variable "architecture" {
  description = "Lambda function architecture"
  type        = string
  default     = "arm64"
  validation {
    condition     = contains(["x86_64", "arm64"], var.architecture)
    error_message = "Architecture must be either x86_64 or arm64."
  }
}

variable "handler" {
  description = "Lambda function handler"
  type        = string
  default     = "bootstrap"
}

variable "timeout" {
  description = "Lambda function timeout in seconds"
  type        = number
  default     = 30
}

variable "memory_size" {
  description = "Lambda function memory size in MB"
  type        = number
  default     = 128
}

variable "table_name" {
  description = "Name of the DynamoDB table"
  type        = string
  default     = "mimic-table"
}

variable "api_name" {
  description = "Name of the API Gateway"
  type        = string
  default     = "mimic-api"
}

variable "api_stage" {
  description = "API Gateway deployment stage"
  type        = string
  default     = "dev"
}

variable "api_quota_limit" {
  description = "Monthly quota limit for API requests"
  type        = number
  default     = 1000
}

variable "api_rate_limit" {
  description = "Rate limit per second"
  type        = number
  default     = 10
}

variable "api_burst_limit" {
  description = "Burst limit for API requests"
  type        = number
  default     = 20
}