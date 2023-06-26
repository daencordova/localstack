# Programando ejecución de función Lambda con EventBridge en LocalStack

Este ejemplo sirve como referencia para programar la ejecuion de una funcion Lambda usando EventBridge para programar una regla que invoca a la funcion Lambda cada 3 minutos, el cual imprime en los logs un nuevo mensaje en ese intervalo de tiempo programado.

## Instalación

Antes de comenzar primero debes tener LocalStack instalado y ejecutándose

```bash
$ localstack start
```

Para crear un archivo ZIP con el código fuente de la función Lambda, puedes ejecutar el siguiente comando en tu terminal:

```bash
$ zip function.zip lambda_function.py
```

Este comando creará un archivo ZIP llamado lambda_function.zip que contiene el archivo lambda_function.py.

Terminal output:

```bash
adding: lambda_function.py (deflated 23%)
```

Ejecuta el siguiente comando en la terminal para crear la función Lambda:

```bash
$ awslocal lambda create-function --function-name PythonLambdaFunction --handler lambda_function.lambda_handler --runtime python3.10 --timeout 30 --memory-size 256 --role arn:aws:iam::123456789012:role/PythonLambdaFunctionRole --zip-file fileb://./function.zip
```

Este comando creará una función Lambda de AWS llamada PythonLambdaFunction con toda la configuracion antes descrita.

```bash
{
    "FunctionName": "PythonLambdaFunction",
    "FunctionArn": "arn:aws:lambda:us-east-1:000000000000:function:PythonLambdaFunction",
    "Runtime": "python3.10",
    "Role": "arn:aws:iam::123456789012:role/MyLambdaRole",
    "Handler": "lambda_function.lambda_handler",
    "CodeSize": 274,
    "Description": "",
    "Timeout": 30,
    "MemorySize": 256,
    "LastModified": "2023-06-19T14:47:12.828392+0000",
    "CodeSha256": "QHP7C8M4mDe++gRHxd8RlKhpnhxdODbXs0NxWa1FT18=",
    "Version": "$LATEST",
    "TracingConfig": {
        "Mode": "PassThrough"
    },
    "RevisionId": "c465c1e5-b8db-47d3-9123-41996c91730e",
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

Ejecuta el siguiente comando en la terminal para crear una regla de EventBridge que se ejecute cada 3 minutos:

```bash
$ awslocal events put-rule --name PythonLambdaFunctionEvent --schedule-expression "rate(3 minutes)"
```

Este comando creará una regla de EventBridge con el nombre "PythonLambdaFunctionEvent" que se ejecutará cada 3 minutos.

```bash
{
    "RuleArn": "arn:aws:events:us-east-1:000000000000:rule/PythonLambdaFunctionEvent"
}
```

Ejecuta el siguiente comando en la terminal para agregar la función Lambda a la regla de EventBridge:

```bash
$ awslocal events put-targets --rule PythonLambdaFunctionEvent --targets "Id"="PythonLambdaFunction","Arn"="arn:aws:lambda:us-east-1:000000000000:function:PythonLambdaFunction"
```

Este comando agrega la función Lambda PythonLambdaFunction a la regla de EventBridge "PythonLambdaFunctionEvent".

```bash
{
    "FailedEntryCount": 0,
    "FailedEntries": []
}
```

Verifica que la función Lambda se haya ejecutado correctamente cada 3 minutos al verificar los registros del contenedor de LocalStack o utilizando el siguiente comando en la terminal:

```bash
$ awslocal logs describe-log-groups --log-group-name-prefix /aws/lambda/PythonLambdaFunction
```

```bash
{
    "logGroups": [
        {
            "logGroupName": "/aws/lambda/PythonLambdaFunction",
            "creationTime": 1687186578407,
            "metricFilterCount": 0,
            "arn": "arn:aws:logs:us-east-1:000000000000:log-group:/aws/lambda/PythonLambdaFunction:*",
            "storedBytes": 1212
        }
    ]
}
```

Verifica que la función Lambda se haya activado ejecutando el siguiente comando en tu terminal:

```bash
$ awslocal logs get-log-events --log-group-name /aws/lambda/PythonLambdaFunction --endpoint-url=http://localhost:4566 --region us-east-1 --log-stream-name $(awslocal logs describe-log-streams --log-group-name /aws/lambda/PythonLambdaFunction --query 'logStreams[].logStreamName' --output text --endpoint-url=http://localhost:4566 --region us-east-1)
```


Este comando obtendrá los registros de la función Lambda PythonLambdaFunction en LocalStack y los mostrará en tu terminal. Si todo ha funcionado correctamente, deberías ver un registro que indica que la función se ha activado con éxito y muestra el mensaje que retorna la función con codigo Python.

```bash
{
    "events": [
        {
            "timestamp": 1687282509110,
            "message": "START RequestId: b85dbdf7-17e8-4daa-9321-54a2cd15f902 Version: $LATEST",
            "ingestionTime": 1687282509313
        },
        {
            "timestamp": 1687282509145,
            "message": "Lambda function was executed by EventBridge",
            "ingestionTime": 1687282509313
        },
        {
            "timestamp": 1687282509181,
            "message": "END RequestId: b85dbdf7-17e8-4daa-9321-54a2cd15f902",
            "ingestionTime": 1687282509313
        },
        {
            "timestamp": 1687282509217,
            "message": "REPORT RequestId: b85dbdf7-17e8-4daa-9321-54a2cd15f902\tDuration: 4.42 ms\tBilled Duration: 5 ms\tMemory Size: 128 MB\tMax Memory Used: 128 MB\t",
            "ingestionTime": 1687282509313
        },
        {
            "timestamp": 1687282688095,
            "message": "START RequestId: 93641bf9-140b-499b-8fec-e2c725fe531f Version: $LATEST",
            "ingestionTime": 1687282688149
        },
        {
            "timestamp": 1687282688104,
            "message": "Lambda function was executed by EventBridge",
            "ingestionTime": 1687282688149
        },
        {
            "timestamp": 1687282688113,
            "message": "END RequestId: 93641bf9-140b-499b-8fec-e2c725fe531f",
            "ingestionTime": 1687282688149
        },
        {
            "timestamp": 1687282688122,
            "message": "REPORT RequestId: 93641bf9-140b-499b-8fec-e2c725fe531f\tDuration: 1.36 ms\tBilled Duration: 2 ms\tMemory Size: 128 MB\tMax Memory Used: 128 MB\t",
            "ingestionTime": 1687282688149
        }
    ],
    "nextForwardToken": "f/00000000000000000000000000000000000000000000000000000007",
    "nextBackwardToken": "b/00000000000000000000000000000000000000000000000000000000"
}
```
