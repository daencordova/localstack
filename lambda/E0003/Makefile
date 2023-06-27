zip-pycode:
	zip lambda.zip lambda_function.py

send-message:
	awslocal sqs send-message --message-body '{"message": "Hello, world!"}' --queue-url http://localhost:4566/000000000000/SQSQueue --endpoint-url=http://localhost:4566 --region us-east-1