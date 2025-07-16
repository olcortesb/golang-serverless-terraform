# 00 - Basic Go Lambda

Basic Go Lambda function deployed with Terraform using `provided.al2023` runtime.

## Structure

```
00_GST_lambda/
├── src/
│   ├── go.mod          # Go module
│   ├── main.go         # Source code
│   ├── go.sum          # Go dependencies checksum
│   └── bootstrap       # Compiled binary (generated)
├── main.tf             # Terraform resources
├── variables.tf        # Configurable variables
├── outputs.tf          # Module outputs
├── providers.tf        # Provider configuration
├── backend.tf          # Terraform backend
├── lambda_function.zip # Deployment package (generated)
├── response.json       # Test response (generated)
└── README.md           # This documentation
```

## Why `provided.al2023`?

- **Runtime `go1.x` deprecated**: AWS deprecated all native Go runtimes
- **ARM64 support**: 50% cheaper than x86_64
- **Full control**: Always use the latest Go version
- **Better performance**: Native binary without overhead

## Step-by-Step Deployment Guide

### 1. Clone the Repository

```bash
# Clone the repository
git clone https://github.com/your-username/golang-serverless-terraform.git
cd golang-serverless-terraform/00_GST_lambda
```

### 2. Review the Project Structure

The repository already contains all necessary files:

- **src/main.go**: Lambda function code
- **src/go.mod**: Go module definition
- **main.tf**: Lambda resource definition
- **variables.tf**: Configurable variables
- **outputs.tf**: Output definitions
- **providers.tf**: AWS provider configuration
- **backend.tf**: Terraform backend configuration

### 3. Configure AWS Credentials

Make sure your AWS credentials are properly configured:

```bash
# Option 1: Using environment variables
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_REGION="us-east-1"

# Option 2: Using AWS CLI
aws configure
```

### 4. Deploy with Terraform

```bash
# Initialize Terraform
terraform init

# View deployment plan
terraform plan

# Apply changes
terraform apply -auto-approve
```

### 5. Test the Lambda Function

```bash
# Invoke the Lambda function
aws lambda invoke --function-name go-hello-serverless-lambda response.json

# View the response
cat response.json
```

Expected output: `"Hello λ!"`

### 6. Clean Up

```bash
# Destroy all resources when done
terraform destroy -auto-approve
```

## Common Issues and Solutions

### 1. Invalid Go Version

**Error:**
```
go: errors parsing go.mod: invalid go version '1.24.5': must match format 1.23
```

**Solution:**
Edit `go.mod` to use a valid Go version format like `go 1.23` or `go 1.22`.

### 2. Bootstrap Not Found

**Error:**
```json
{
  "errorType": "Runtime.InvalidEntrypoint",
  "errorMessage": "Couldn't find valid bootstrap(s): [/var/task/bootstrap /opt/bootstrap]"
}
```

**Solution:**
Ensure the compiled binary is named `bootstrap` and not `main`.

## Outputs

- `lambda_function_name`: Lambda function name
- `lambda_function_arn`: Function ARN
- `lambda_invoke_arn`: ARN to invoke the function
- `lambda_role_arn`: Execution role ARN