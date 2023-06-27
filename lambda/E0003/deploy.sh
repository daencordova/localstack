#!/bin/bash

QUEUE_NAME=SQSQueue
LAMBDA_NAME=PythonLambdaFunction
LAMBDA_ROLE_NAME=LambdaSQSRole
LAMBDA_SQS_POLICY_NAME=LambdaFunctionSQSPolicy
LAMBDA_LOGS_POLICY_NAME=LambdaFunctionLOGSPolicy

awslocal sqs create-queue \
    --queue-name ${QUEUE_NAME} \
    --endpoint-url=http://localhost:4566 \
    --region us-east-1

awslocal iam create-policy \
    --policy-name ${LAMBDA_SQS_POLICY_NAME} \
    --policy-document '{"Version": "2012-10-17","Statement": [{"Effect": "Allow","Action": ["sqs:ReceiveMessage","sqs:DeleteMessage"],"Resource": "arn:aws:sqs:us-east-1:000000000000:${QUEUE_NAME}"}]}' \
    --endpoint-url=http://localhost:4566 \
    --region us-east-1

awslocal iam create-policy \
    --policy-name ${LAMBDA_LOGS_POLICY_NAME} \
    --policy-document '{"Version": "2012-10-17","Statement": [{"Effect": "Allow","Action": ["logs:CreateLogGroup","logs:CreateLogStream","logs:PutLogEvents"],"Resource": "arn:aws:logs:*:*:*"}]}'\
    --endpoint-url=http://localhost:4566 \
    --region us-east-1

awslocal iam create-role \
    --role-name ${LAMBDA_ROLE_NAME} \
    --assume-role-policy-document '{"Version": "2012-10-17", "Statement": [{"Effect": "Allow", "Principal": {"Service": "lambda.amazonaws.com"}, "Action": "sts:AssumeRole"}]}' \
    --endpoint-url=http://localhost:4566 \
    --region us-east-1

awslocal iam attach-role-policy \
    --role-name ${LAMBDA_ROLE_NAME} \
    --policy-arn arn:aws:iam::000000000000:policy/${LAMBDA_SQS_POLICY_NAME} \
    --endpoint-url=http://localhost:4566 \
    --region us-east-1

awslocal iam attach-role-policy \
    --role-name ${LAMBDA_ROLE_NAME} \
    --policy-arn arn:aws:iam::000000000000:policy/${LAMBDA_LOGS_POLICY_NAME} \
    --endpoint-url=http://localhost:4566 \
    --region us-east-1

awslocal lambda create-function \
    --function-name ${LAMBDA_NAME} \
    --runtime python3.10 \
    --timeout 5 \
    --memory-size 128 \
    --handler lambda_function.lambda_handler \
    --role arn:aws:iam::000000000000:role/${LAMBDA_ROLE_NAME} \
    --zip-file fileb://./lambda.zip \
    --endpoint-url=http://localhost:4566 \
    --region us-east-1

awslocal lambda create-event-source-mapping \
    --function-name ${LAMBDA_NAME} \
    --batch-size 1 \
    --event-source-arn arn:aws:sqs:us-east-1:000000000000:${QUEUE_NAME} \
    --endpoint-url=http://localhost:4566 \
    --region us-east-1
