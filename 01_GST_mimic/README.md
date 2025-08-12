# 01 - Go Lambda with API Gateway and DynamoDB

Serverless JSON storage API built with Go Lambda functions, API Gateway, and DynamoDB. Acts as an in-memory database that can store and retrieve any JSON data.

## Structure

```
01_GST_mimic/
├── src/
│   ├── request/
│   │   ├── go.mod          # Go module for POST lambda
│   │   ├── main.go         # POST handler source code
│   │   └── bootstrap       # Compiled binary (generated)
│   └── response/
│       ├── go.mod          # Go module for GET lambda
│       ├── main.go         # GET handler source code
│       └── bootstrap       # Compiled binary (generated)
├── apigateway.tf           # API Gateway configuration
├── dynamo.tf               # DynamoDB table
├── lambdarequest.tf        # POST Lambda function and IAM
├── lambdaresponse.tf       # GET Lambda function
├── random.tf               # Random suffix for resources
├── variables.tf            # Configurable variables
├── outputs.tf              # Module outputs
├── providers.tf            # Provider configuration
├── backend.tf              # Terraform backend
└── README.md               # This documentation
```

## API Endpoints

- **POST /mimic**: Store any JSON data, returns generated ID
- **GET /mimic/{id}**: Retrieve JSON data by ID

## Features

- **Generic JSON Storage**: Accepts and stores any valid JSON structure
- **API Key Protection**: Requires API key with monthly quota
- **ARM64 Lambda**: Cost-optimized with Graviton2 processors
- **Separate Lambda Functions**: Independent scaling for read/write operations
- **Random Resource Naming**: Avoids deployment conflicts

## Step-by-Step Deployment Guide

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/golang-serverless-terraform.git
cd golang-serverless-terraform/01_GST_mimic
```

### 2. Configure AWS Credentials

```bash
# Option 1: Using environment variables
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_REGION="us-east-1"

# Option 2: Using AWS CLI
aws configure
```

### 3. Deploy with Terraform

```bash
# Initialize Terraform
terraform init

# View deployment plan
terraform plan

# Apply changes
terraform apply
```

### 4. Test the API

```bash
# Get the API Gateway URL and API Key from outputs
API_URL=$(terraform output -raw api_gateway_url)
API_KEY=$(terraform output -raw api_key_value)

# Store JSON data
curl -X POST "${API_URL}/mimic" \
  -H "x-api-key: ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{"name": "John", "age": 30, "city": "New York"}'

# Response: "uuid-generated-id"

# Retrieve JSON data
curl -X GET "${API_URL}/mimic/uuid-generated-id" \
  -H "x-api-key: ${API_KEY}"

# Response: {"id": "uuid-generated-id", "body": {"name": "John", "age": 30, "city": "New York"}}
```

### 5. Clean Up

```bash
terraform destroy
```

## Configuration Variables

```hcl
function_name     = "go-mimic-lambda"           # Base Lambda function name
table_name        = "mimic-table"               # DynamoDB table name
api_name          = "mimic-api"                 # API Gateway name
api_quota_limit   = 1000                        # Monthly API quota
api_rate_limit    = 10                          # Requests per second
api_burst_limit   = 20                          # Burst limit
runtime           = "provided.al2023"           # Lambda runtime
architecture      = "arm64"                    # Lambda architecture
timeout           = 30                          # Lambda timeout (seconds)
memory_size       = 128                         # Lambda memory (MB)
```

## Outputs

- `api_gateway_url`: API Gateway endpoint URL
- `api_key_value`: API key for authentication (sensitive)
- `resource_suffix`: Random suffix used for resource names
- `create_lambda_function_name`: POST Lambda function name
- `get_lambda_function_name`: GET Lambda function name
- `dynamodb_table_name`: DynamoDB table name

## Example JSON Payloads

### Store User Data
```json
{
  "name": "Alice",
  "email": "alice@example.com",
  "preferences": {
    "theme": "dark",
    "notifications": true
  }
}
```

### Store Product Information
```json
{
  "product": "Laptop",
  "price": 999.99,
  "specs": {
    "cpu": "Intel i7",
    "ram": "16GB",
    "storage": "512GB SSD"
  },
  "tags": ["electronics", "computers"]
}
```

### Store Any JSON Structure
```json
{
  "timestamp": "2024-01-15T10:30:00Z",
  "data": [1, 2, 3, 4, 5],
  "metadata": {
    "version": "1.0",
    "source": "api"
  }
}
```

## Architecture

- **API Gateway**: REST API with API key authentication
- **Lambda Functions**: Two separate functions for POST/GET operations
- **DynamoDB**: NoSQL database for JSON storage
- **IAM Roles**: Least privilege access for Lambda functions
- **Random Naming**: Prevents resource conflicts during deployment