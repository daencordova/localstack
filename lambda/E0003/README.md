# Función Lambda que recibe mensajes de una cola SQS en LocalStack

Este ejemplo sirve como referencia para consumir mensajes de una cola SQS en una función Lambda, cargando o enviando un mensaje a la cola SQS via terminal y luego extrayendo tal mensaje usando la función Lambda. Se crearon los permisos y roles para tales situciones.

## Instalación

Antes de comenzar primero debes tener LocalStack instalado y ejecutándose

```bash
$ localstack start
```

Para crear un archivo ZIP con el código fuente de la función Lambda, puedes ejecutar el siguiente comando en tu terminal:

```bash
$ zip lambda.zip lambda_function.py
```

Este comando creará un archivo ZIP llamado lambda.zip que contiene el archivo lambda_function.py.

Crea una cola SQS ejecutando en LocalStack el siguiente comando en tu terminal

```bash
$ awslocal sqs create-queue --queue-name SQSQueue --endpoint-url=http://localhost:4566 --region us-east-1
```

Este comando creará una cola SQS llamada SQSQueue en LocalStack.

```bash
{
    "QueueUrl": "http://localhost:4566/000000000000/SQSQueue"
}
```

Para recibir y eliminar mensajes de la cola SQS, necesitas crear una política de permisos que permita a la función Lambda realizar estas acciones. Puedes utilizar el siguiente comando para crear una política de permisos:

```bash
$ awslocal iam create-policy --policy-name LambdaFunctionSQSPolicy --policy-document '{"Version": "2012-10-17","Statement": [{"Effect": "Allow","Action": ["sqs:ReceiveMessage","sqs:DeleteMessage"],"Resource": "arn:aws:sqs:us-east-1:000000000000:SQSQueue"}]}' --endpoint-url=http://localhost:4566 --region us-east-1
```

Este comando crea una política de permisos llamada LambdaFunctionSQSPolicy que permite a la función Lambda recibir y eliminar mensajes de la cola SQS prueba-cola.

```bash
{
    "Policy": {
        "PolicyName": "LambdaFunctionSQSPolicy",
        "PolicyId": "AOODW322AW9R7ZQT3LJ7J",
        "Arn": "arn:aws:iam::000000000000:policy/LambdaFunctionSQSPolicy",
        "Path": "/",
        "DefaultVersionId": "v1",
        "AttachmentCount": 0,
        "CreateDate": "2023-06-21T22:47:38.470000Z",
        "UpdateDate": "2023-06-21T22:47:38.470000Z",
        "Tags": []
    }
}
```

Para crear grupos y flujos de registro en CloudWatch Logs, necesitas crear una política de permisos que permita a la función Lambda realizar estas acciones. Puedes utilizar el siguiente comando para crear una política de permisos:

```bash
$ awslocal iam create-policy --policy-name LambdaFunctionLOGSPolicy --policy-document '{"Version": "2012-10-17","Statement": [{"Effect": "Allow","Action": ["logs:CreateLogGroup","logs:CreateLogStream","logs:PutLogEvents"],"Resource": "arn:aws:logs:*:*:*"}]}' --endpoint-url=http://localhost:4566 --region us-east-1
```

Este comando crea una política de permisos llamada LambdaFunctionLOGSPolicy que permite a la función Lambda crear grupos y flujos de registro en CloudWatch Logs.

```bash
{
    "Policy": {
        "PolicyName": "LambdaFunctionLOGSPolicy",
        "PolicyId": "AA64CGREUJOEAEWUPS30T",
        "Arn": "arn:aws:iam::000000000000:policy/LambdaFunctionLOGSPolicy",
        "Path": "/",
        "DefaultVersionId": "v1",
        "AttachmentCount": 0,
        "CreateDate": "2023-06-21T22:50:48.637000Z",
        "UpdateDate": "2023-06-21T22:50:48.637000Z",
        "Tags": []
    }
}
```

Para que la función Lambda pueda asumir las políticas de permisos creadas anteriormente, necesitas crear un rol de IAM. Puedes utilizar el siguiente comando para crear un rol de IAM:

```bash
$ awslocal iam create-role --role-name LambdaSQSRole --assume-role-policy-document '{"Version": "2012-10-17", "Statement": [{"Effect": "Allow", "Principal": {"Service": "lambda.amazonaws.com"}, "Action": "sts:AssumeRole"}]}' --endpoint-url=http://localhost:4566 --region us-east-1
```

Este comando crea un rol de IAM llamado LambdaSQSRole que permite a la función Lambda asumir el rol.

```bash
{
    "Role": {
        "Path": "/",
        "RoleName": "LambdaSQSRole",
        "RoleId": "AROAQAAAAAAAK63L26B4B",
        "Arn": "arn:aws:iam::000000000000:role/LambdaSQSRole",
        "CreateDate": "2023-06-21T22:55:33.326000Z",
        "AssumeRolePolicyDocument": {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Effect": "Allow",
                    "Principal": {
                        "Service": "lambda.amazonaws.com"
                    },
                    "Action": "sts:AssumeRole"
                }
            ]
        }
    }
}
```

Para que la función Lambda tenga los permisos necesarios para recibir y eliminar mensajes de la cola SQS, y crear grupos y flujos de registro en CloudWatch Logs, necesitas asignar las políticas de permisos creadas anteriormente al rol de IAM. Puedes utilizar los siguientes comandos para asignar las políticas de permisos:

```bash
$ awslocal iam attach-role-policy --role-name LambdaSQSRole --policy-arn arn:aws:iam::000000000000:policy/LambdaFunctionSQSPolicy --endpoint-url=http://localhost:4566 --region us-east-1
```

```bash
$ awslocal iam attach-role-policy --role-name LambdaSQSRole --policy-arn arn:aws:iam::000000000000:policy/LambdaFunctionLOGSPolicy --endpoint-url=http://localhost:4566 --region us-east-1
```

Estos comandos asignan las políticas de permisos LambdaFunctionSQSPolicy y LambdaFunctionLOGSPolicy al rol LambdaSQSRole.

Este comando crea una función Lambda llamada prueba-lambda que utiliza el archivo lambda_function.zip como código fuente y el rol de IAM LambdaSQSRole. 

```bash
$ awslocal lambda create-function --function-name PythonLambdaFunction --runtime python3.10 --timeout 5 --memory-size 128 --handler lambda_function.lambda_handler --role arn:aws:iam::000000000000:role/LambdaSQSRole --zip-file fileb://./lambda.zip --endpoint-url=http://localhost:4566 --region us-east-1
```

Este comando creará la función Lambda PythonLambdaFunction en LocalStack utilizando el archivo ZIP lambda.zip como código fuente.

```bash
{
    "FunctionName": "PythonLambdaFunction",
    "FunctionArn": "arn:aws:lambda:us-east-1:000000000000:function:PythonLambdaFunction",
    "Runtime": "python3.10",
    "Role": "arn:aws:iam::123456789012:role/PythonLambdaFunctionRole",
    "Handler": "lambda_function.lambda_handler",
    "CodeSize": 453,
    "Description": "",
    "Timeout": 3,
    "MemorySize": 128,
    "LastModified": "2023-06-21T23:00:32.353586+0000",
    "CodeSha256": "8LWmuvcv9WnTpxIz2TNIiKcdjCAVGDRTxZthDFRIcmc=",
    "Version": "$LATEST",
    "TracingConfig": {
        "Mode": "PassThrough"
    },
    "RevisionId": "b645026a-cb33-4e43-9634-1a9f6db736cd",
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

Para hacer que la función Lambda reciba mensajes de la cola SQS, necesitas agregar un evento de cola SQS a la función Lambda. Puedes utilizar el siguiente comando para hacerlo:

```bash
$ awslocal lambda create-event-source-mapping --function-name PythonLambdaFunction --batch-size 1 --event-source-arn arn:aws:sqs:us-east-1:000000000000:SQSQueue --endpoint-url=http://localhost:4566 --region us-east-1
```

Este comando configurará un disparador de cola SQS para la función Lambda PythonLambdaFunction, lo que significa que la función se activará automáticamente cuando se reciba un mensaje en la cola SQS SQSQueue.

Para obtener la URL de la cola SQS, puedes ejecutar el siguiente comando:

```bash
$ awslocal sqs get-queue-url --queue-name SQSQueue --endpoint-url=http://localhost:4566 --region us-east-1
```

Este comando obtendrá la URL de la cola SQS SQSQueue en LocalStack para luego enviar un mensaje a ella y la mostrará en tu terminal.

```bash
{
    "QueueUrl": "http://localhost:4566/000000000000/SQSQueue"
}
```

Luego, para enviar un mensaje a la cola SQS utilizando la URL, puedes ejecutar el siguiente comando:

```bash
$ awslocal sqs send-message --queue-url http://localhost:4566/000000000000/SQSQueue --message-body '{"message": "Hello, world!"}' --endpoint-url=http://localhost:4566 --region us-east-1
```

Este comando enviará un mensaje con el cuerpo {"message": "Hello, world!"} a la cola SQS SQSQueue en LocalStack.

```bash
{
    "MD5OfMessageBody": "6bb11419793d141bf2a1ea48e0b4d835",
    "MessageId": "2003355b-2cf9-4383-9649-84c83a93907b"
}
```

Verifica que la función Lambda se haya activado ejecutando el siguiente comando en tu terminal:

```bash
$ awslocal logs get-log-events --log-group-name /aws/lambda/PythonLambdaFunction --log-stream-name --endpoint-url=http://localhost:4566 --region us-east-1 $(awslocal logs describe-log-streams --log-group-name /aws/lambda/PythonLambdaFunction --query 'logStreams[].logStreamName' --output text --endpoint-url=http://localhost:4566 --region us-east-1)
```

Este comando obtendrá los registros de la función Lambda PythonLambdaFunction en LocalStack y los mostrará en tu terminal. Si todo ha funcionado correctamente, deberías ver un registro que indica que la función se ha activado con éxito y ha procesado el mensaje de la cola SQS.

```bash
{
    "events": [
        {
            "timestamp": 1687388905657,
            "message": "START RequestId: 222ae37c-d7d5-4ff4-b8e8-ef7f16b8e1bd Version: $LATEST",
            "ingestionTime": 1687388905845
        },
        {
            "timestamp": 1687388905689,
            "message": "Processing message: {'message': 'Hello, world!'}",
            "ingestionTime": 1687388905845
        },
        {
            "timestamp": 1687388905722,
            "message": "END RequestId: 222ae37c-d7d5-4ff4-b8e8-ef7f16b8e1bd",
            "ingestionTime": 1687388905845
        },
        {
            "timestamp": 1687388905755,
            "message": "REPORT RequestId: 222ae37c-d7d5-4ff4-b8e8-ef7f16b8e1bd\tDuration: 3.65 ms\tBilled Duration: 4 ms\tMemory Size: 128 MB\tMax Memory Used: 128 MB\t",
            "ingestionTime": 1687388905845
        }
    ],
    "nextForwardToken": "f/00000000000000000000000000000000000000000000000000000003",
    "nextBackwardToken": "b/00000000000000000000000000000000000000000000000000000000"
}
```
