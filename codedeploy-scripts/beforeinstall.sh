#!/bin/bash

# Nos movemos al directorio de la app
cd opt/codeplay-agent/deployment-root/$DEPLOYMENT_GROUP_ID/$DEPLOYMENT_ID/deployment-archive

# Cambiamos los permisos del archivo gradlew
chmod +x gradlew

# Ejecutamos la tarea war
./gradlew war

# Copiamos el war a la carpeta de tomcat
mv build/libs/holamundo.war opt/codeplay-agent/deployment-root/$DEPLOYMENT_GROUP_ID/$DEPLOYMENT_ID/deployment-archive/tmp/codigo/holamundo.war