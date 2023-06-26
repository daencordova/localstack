include .env

.PHONY: build down invoke-function

build:
	@docker-compose up --build

down:
	@docker-compose down

invoke-function:
	awslocal lambda invoke \
		--function-name PythonLambdaFunction \
		--endpoint-url=http://localhost:4566 \
		--region us-east-1 \
		response.json