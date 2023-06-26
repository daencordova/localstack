#!/bin/sh

# CONFIGURACIONES POR DEFECTO DEL ENTORNO
LOCALSTACK_PORT=4566
SERVICE_URL=http://localhost:${LOCALSTACK_PORT}
DEFAULT_REGION_NAME=us-east-1

# CONFIGURACIONES DE LA FUNCION LAMBDA
FUNCTION_NAME=PythonLambdaFunction
FUNCTION_ROLE_NAME=LambdaFunctionRole

# Empaqueta en un archivo .zip el codigo que sera ejecutado por la function Lambda
echo "Empaquetando archivo .zip para ser ejecutado por la funcion Lambda..."
zip function.zip lambda_function.py

echo "Creando funcion Lambda en LocalStack..."
awslocal lambda create-function \
    --function-name $FUNCTION_NAME \
    --handler lambda_function.lambda_handler \
    --runtime python3.10 \
    --timeout 5 \
    --memory-size 128 \
    --role arn:aws:iam::123456789012:role/${FUNCTION_ROLE_NAME} \
    --zip-file fileb://./function.zip \
    --endpoint-url=${SERVICE_URL} \
    --region ${DEFAULT_REGION_NAME}

# Espera 10 segundos para que termine de crear la funcion Lambda
# antes de hacer la invocacion de la funcion.
sleep 10

# Bucle infinito para simular un evento de AWS invocando a la funcion Lambda cada minuto
echo "Invocando a la funcion lambda..."
while true
do
    CURRENT_TIME=$(date +"%d-%m-%YT%H:00:00Z")
    echo "Lambda function invoked at: ${CURRENT_TIME}"
    awslocal lambda invoke \
        --function-name ${FUNCTION_NAME} \
        --endpoint-url=${SERVICE_URL} \
        --region ${DEFAULT_REGION_NAME} \
        response.json
    sleep 60
done
