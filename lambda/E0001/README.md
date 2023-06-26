# Simple función Lambda en LocalStack

Este ejemplo sirve como referencia para probar el funcionamiento de una función Lambda que cuando se invoca imprime un mensaje en un archivo.

## Instalación

Antes de comenzar primero debes inciar LocalStack con siguiente comando:

```bash
$ make build
```

Levanta y ejecutado el contenedor para ejecutar todos los servicios

Puedes darle permisos de ejecución y preparar el entorno en LocalStack ejecutando el siguiente comando en tu terminal:

```bash
$ chmod +x deploy && ./deploy
```

Este comando creará un archivo .zip que será ejecutado por la función Lambda en LocalStack. Luego, creará la función Lambda usando el archivo function.zip como código fuente. Finalmente, invocará a la función cada 60 segundos e imprimirá una salida en un archivo response.json.

Archivo response.json:

```
{"statusCode": 200, "headers": {"Content-Type": "application/json"}, "body": {"sum": 30}}
```