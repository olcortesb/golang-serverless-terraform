# Golang Serverless Terraform

Complete guide to deploy serverless applications in Go using Terraform and AWS Lambda.

## Project Structure

```
golang-serverless-terraform/
├── README.md
├── 00_GST_lambda/          # Basic Go Lambda
├── 01_GST_mimic/           # (Roadmap)API Gateway + Lambda + dynamo
├── 02_GST_s3_events/       # (Roadmap)Lambda + S3 Events
├── 03_GST_sqs/             # (Roadmap)Lambda + SQS
└── 04_GST_eventbridge/     # (Roadmap)Lambda + EventBridge
```

## Tutorial Folders

- **00_GST_lambda**: Basic Go Lambda function [Readme](/00_GST_lambda/README.md)
- **01_GST_mimic**: REST API with API Gateway + Persistence with DynamoDB

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