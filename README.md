# Golang Serverless Terraform

Complete guide to deploy serverless applications in Go using Terraform and AWS Lambda.

## Project Structure

```
golang-serverless-terraform/
├── README.md
├── 00_GST_lambda/          # Basic Go Lambda
├── 01_GST_api_gateway/     # (Roadmap)API Gateway + Lambda
├── 02_GST_dynamodb/        # (Roadmap)Lambda + DynamoDB
├── 03_GST_s3_events/       # (Roadmap)Lambda + S3 Events
├── 04_GST_sqs/             # (Roadmap)Lambda + SQS
└── 05_GST_eventbridge/     # (Roadmap)Lambda + EventBridge
```

## Tutorial Folders

- **00_GST_lambda**: Basic Go Lambda function [Readme](/00_GST_lambda/README.md)
- **(Roadmap)01_GST_api_gateway**: REST API with API Gateway
- **(Roadmap)02_GST_dynamodb**: Persistence with DynamoDB
- **(Roadmap)03_GST_s3_events**: S3 event processing
- **(Roadmap)04_GST_sqs**: Message queues with SQS
- **(Roadmap)05_GST_eventbridge**: Event-driven architecture

## Requirements

- Go 1.18+
- Terraform 1.0+
- AWS CLI configured
- Active AWS account

## Quick Start

```bash
cd 00_GST_lambda
terraform init
terraform plan
terraform apply
```