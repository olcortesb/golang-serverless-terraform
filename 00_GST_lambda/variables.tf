variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = "go-hello-serverless-lambda"
}

variable "role_name" {
  description = "Name of the IAM role for Lambda execution"
  type        = string
  default     = "lambda_execution_role"
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