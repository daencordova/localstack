#!/bin/bash

FUNCTION_NAME=PythonLambdaFunction
EVENT_NAME=PythonLambdaFunctionEvent

zip function.zip lambda_function.py

awslocal lambda create-function \
    --function-name ${FUNCTION_NAME} \
    --handler lambda_function.lambda_handler \
    --runtime python3.10 \
    --timeout 5 \
    --memory-size 128 \
    --role arn:aws:iam::123456789012:role/${FUNCTION_NAME}Role \
    --zip-file fileb://./function.zip \
    --endpoint-url=http://localhost:4566 \
    --region us-east-1

awslocal events put-rule \
    --name ${EVENT_NAME} \
    --schedule-expression "rate(3 minutes)" \
    --endpoint-url=http://localhost:4566 \
    --region us-east-1

awslocal events put-targets \
    --rule ${EVENT_NAME} \
    --targets "Id"="${FUNCTION_NAME}","Arn"="arn:aws:lambda:us-east-1:000000000000:function:${FUNCTION_NAME}" \
    --endpoint-url=http://localhost:4566 \
    --region us-east-1