#!/bin/bash

# Nos movemos al directorio de la app
cd opt/codeploy-agent/deployment-root/$DEPLOYMENT_GROUP_ID/$DEPLOYMENT_ID/deployment-archive

# Cambiamos los permisos del archivo gradlew
chmod +x gradlew

# Ejecutamos la tarea war
./gradlew war

# Renombramos el war 
mv build/libs/holamundo-0.0.1-plain.war build/libs/holamundo.war