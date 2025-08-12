// get.go
package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"os"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/dynamodb"
	"github.com/aws/aws-sdk-go/service/dynamodb/dynamodbattribute"
)

type MimicItem struct {
	ID   string                 `json:"id"`
	Body map[string]interface{} `json:"body"`
}

var dynamoClient *dynamodb.DynamoDB
var tableName string

func init() {
	sess := session.Must(session.NewSession())
	dynamoClient = dynamodb.New(sess)
	tableName = os.Getenv("MIMIC_TABLE")
	if tableName == "" {
		tableName = "mimic-table"
	}
}

func getBodyResponse(id string) (*MimicItem, error) {
	result, err := dynamoClient.GetItem(&dynamodb.GetItemInput{
		TableName: aws.String(tableName),
		Key: map[string]*dynamodb.AttributeValue{
			"id": {
				S: aws.String(id),
			},
		},
	})

	if err != nil {
		return nil, err
	}

	if result.Item == nil {
		return nil, fmt.Errorf("item not found")
	}

	var item MimicItem
	err = dynamodbattribute.UnmarshalMap(result.Item, &item)
	if err != nil {
		return nil, err
	}

	return &item, nil
}

func handler(ctx context.Context, request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	id, exists := request.PathParameters["id"]
	if !exists {
		return events.APIGatewayProxyResponse{
			StatusCode: 400,
			Body:       "Missing id parameter",
		}, nil
	}

	log.Printf("Getting mimic item with ID: %s", id)

	item, err := getBodyResponse(id)
	if err != nil {
		log.Printf("Error getting item: %v", err)
		return events.APIGatewayProxyResponse{
			StatusCode: 404,
			Body:       "Item not found",
		}, nil
	}

	responseBody, err := json.Marshal(item)
	if err != nil {
		log.Printf("Error marshaling response: %v", err)
		return events.APIGatewayProxyResponse{
			StatusCode: 500,
			Body:       "Internal server error",
		}, nil
	}

	return events.APIGatewayProxyResponse{
		StatusCode: 200,
		Body:       string(responseBody),
		Headers: map[string]string{
			"Content-Type": "application/json",
		},
	}, nil
}

func main() {
	lambda.Start(handler)
}