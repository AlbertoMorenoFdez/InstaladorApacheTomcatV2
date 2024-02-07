#!/bin/bash

# Nombre de la pila que se va a desplegar
stack_name="TestStack"

# Nombre del archivo YAML de la plantilla
template_file="instancia.yml"

# Comando para desplegar la pila
# El comando 'aws cloudformation deploy' crea o actualiza una pila de CloudFormation
# --stack-name especifica el nombre de la pila
# --template-file especifica el archivo de la plantilla
# --capabilities CAPABILITY_IAM permite a CloudFormation crear o actualizar roles de IAM
if aws cloudformation deploy \
  --stack-name $stack_name \
  --template-file $template_file \
  --capabilities CAPABILITY_IAM
then
  echo "La pila $stack_name ha sido desplegada correctamente."
else
  echo "El despliegue de la pila $stack_name ha fallado."
  exit 1
fi

if [ $? -eq 0 ]; then
    PUBLIC_IP=$(aws cloudformation list-exports \
        --query "Exports[?Name=='${stack_name}-InstancePublicIP'].Value" --output text)

        URL="http://$PUBLIC_IP:8080"

        echo "IP: $PUBLIC_IP"
        echo "URL: $URL"
fi