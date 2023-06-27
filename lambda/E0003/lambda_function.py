import json
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def lambda_handler(event, context):
    try:
        # Extrae el cuerpo del mensaje enviado por la cola SQS
        record = event["Records"][0]
        body = json.loads(record["body"])

        # Retornar una respuesta
        print("Processing message: {}".format(body))
    except Exception as error:
        logger.error(error)
        raise error
