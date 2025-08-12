// create.go
package main

import (
	"context"
	"encoding/json"
	"log"
	"os"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/dynamodb"
	"github.com/aws/aws-sdk-go/service/dynamodb/dynamodbattribute"
	"github.com/google/uuid"
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

func createBodyResponse(body map[string]interface{}) (string, error) {
	id := uuid.New().String()
	mimicItem := MimicItem{
		ID:   id,
		Body: body,
	}

	av, err := dynamodbattribute.MarshalMap(mimicItem)
	if err != nil {
		return "", err
	}

	_, err = dynamoClient.PutItem(&dynamodb.PutItemInput{
		TableName: aws.String(tableName),
		Item:      av,
	})

	return id, err
}

func handler(ctx context.Context, request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	log.Printf("Creating new mimic item")

	var body map[string]interface{}
	err := json.Unmarshal([]byte(request.Body), &body)
	if err != nil {
		log.Printf("Error parsing JSON: %v", err)
		return events.APIGatewayProxyResponse{
			StatusCode: 400,
			Body:       "Invalid JSON",
		}, nil
	}

	id, err := createBodyResponse(body)
	if err != nil {
		log.Printf("Error creating item: %v", err)
		return events.APIGatewayProxyResponse{
			StatusCode: 500,
			Body:       "Internal server error",
		}, nil
	}

	log.Printf("Created item with ID: %s", id)
	return events.APIGatewayProxyResponse{
		StatusCode: 200,
		Body:       id,
	}, nil
}

func main() {
	lambda.Start(handler)
}
