# Simple función Lambda en LocalStack

Este ejemplo sirve como referencia para probar el funcionamiento de una función Lambda que cuando se invoca imprime un mensaje en un archivo.

## Instalación

Antes de comenzar primero debes tener LocalStack instalado y ejecutándose

```bash
$ localstack start
```

Para crear un archivo ZIP con el código fuente de la función Lambda, puedes ejecutar el siguiente comando en tu terminal:

```bash
$ make zip-pycode
```

Este comando creará un archivo ZIP llamado lambda.zip que contiene el archivo lambda_function.py.

Salida en la terminal:

```bash
  adding: lambda_function.py (deflated 44%)
  adding: requirements.txt (stored 0%)
```

Crea la función Lambda en LocalStack ejecutando el siguiente comando en tu terminal:

```bash
$ ./deploy
```

Este comando crea la función Lambda PythonLambdaFunction en LocalStack, utilizando el archivo lambda.zip como código fuente.

Salida en la terminal:

```bash
{
    "FunctionName": "PythonLambdaFunction",
    "FunctionArn": "arn:aws:lambda:us-east-1:000000000000:function:PythonLambdaFunction",
    "Runtime": "python3.10",
    "Role": "arn:aws:iam::123456789012:role/PythonLambdaFunctionRole",
    "Handler": "lambda_function.lambda_handler",
    "CodeSize": 564,
    "Description": "",
    "Timeout": 5,
    "MemorySize": 128,
    "LastModified": "2023-06-20T15:34:51.538969+0000",
    "CodeSha256": "Ag0YwJVAsKmKuY9S/H+hhlDnTVwsEKzCfvRj6CGCr9g=",
    "Version": "$LATEST",
    "TracingConfig": {
        "Mode": "PassThrough"
    },
    "RevisionId": "2c4b1ec7-49da-4743-b3c2-eaa4d51ae18a",
    "State": "Pending",
    "StateReason": "The function is being created.",
    "StateReasonCode": "Creating",
    "PackageType": "Zip",
    "Architectures": [
        "x86_64"
    ],
    "EphemeralStorage": {
        "Size": 512
    },
    "SnapStart": {
        "ApplyOn": "None",
        "OptimizationStatus": "Off"
    },
    "RuntimeVersionConfig": {
        "RuntimeVersionArn": "arn:aws:lambda:us-east-1::runtime:8eeff65f6809a3ce81507fe733fe09b835899b99481ba22fd75b5a7338290ec1"
    }
}
```

Ahora puedes probar la función Lambda en LocalStack ejecutando el siguiente comando:

```bash
$ make invoke-function
```

Este comando invoca la función Lambda MyFunction y guarda el resultado en un archivo llamado output.json

Salida en la terminal:

```bash
awslocal lambda invoke \
        --function-name PythonLambdaFunction \
        --endpoint-url=http://localhost:4566 \
        --region us-east-1 \
        output.json
{
    "StatusCode": 200,
    "ExecutedVersion": "$LATEST"
}
```

Archivo output.json:

```
{"statusCode": 200, "headers": {"Content-Type": "application/json"}, "body": {"sum": 30}}
```