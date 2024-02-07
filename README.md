# Proyecto AWS CloudFormation para la asignatura Despliegue de Aplicaciones Web

Este proyecto contiene scripts y plantillas de AWS CloudFormation para desplegar y administrar recursos de AWS de forma automatizada, asi ocmo la instalación de Apache Tomcat 10 en un entorno Ububtu 20.04.
Es importante ejecutar los scripts con permisos de superusuario.

## Archivos en este proyecto

- `desplegar.sh`: Este script despliega una pila de AWS CloudFormation utilizando la plantilla especificada en el archivo `instancia.yml`.
  
- `instancia.yml`: Esta es una plantilla de AWS CloudFormation que define un grupo de seguridad y una instancia de EC2. En la segunda version de esta instancia se automatiza tanto la creación de la instancia como la instalacion de Apache Tomcat

- `instaladorApacheTomcat.sh`: Este script instala Apache Tomcat en una instancia de EC2. 

- `borrar.sh`: Este script elimina una pila de AWS CloudFormation. El nombre de la pila está codificado en el script.

## Instrucciones de uso 
1. Para el despliegue de la Pila de CloudFormation:
   
    Ejecute `desplegar.sh` proporcionando los permisos necesarios.
    Esto desplegará la infraestructura definida en instancia.yaml.   
    Después de que la pila de CloudFormation se despliegue correctamente, comenzará la instalación de Apache Tomtac dentro de la instancia, para ello este script instalará Java JDK, descargará Apache Tomcat, configurará usuarios 
    administrativos y establecerá Tomcat como un servicio systemd.
    Posteriormente instalará Git y clonará nuestro propio repositorio, se cambiaran los permisos del archivo gradlew, ejecutará la tarea war creando un archivo.war que se copiará a la carpeta webapps de Tomcat desde donde será            servido.

1. Eliminación de la Pila de CloudFormation:
   
    Si ya no necesita la infraestructura, ejecute `borrar.sh`para eliminar la pila de CloudFormation.

## Instrucciones de uso 
1. Para el despliegue de la Pila de CloudFormation:
   
    Ejecute `desplegar.sh` proporcionando los permisos necesarios.
    Esto desplegará la infraestructura definida en instancia.yaml.

1. Instalación de Apache Tomcat:
   
    Después de que la pila de CloudFormation se despliegue correctamente, conéctese a la instancia EC2.
    Ejecute `instaladorApacheTomcat.sh`para instalar y configurar Apache Tomcat.
    Este script instalará Java JDK, descargará Apache Tomcat, configurará usuarios administrativos y establecerá Tomcat como un servicio systemd.

1. Eliminación de la Pila de CloudFormation:
   
    Si ya no necesita la infraestructura, ejecute `borrar.sh`para eliminar la pila de CloudFormation.

### Prerrequisitos
- Ubuntu 20.04
- Permisos de superusuario (sudo)
- AWS CLI instalado y configurado.
- Permisos suficientes para crear y eliminar pilas de CloudFormation, instancias EC2 y grupos de seguridad.

### Despliegue

Para desplegar la pila de CloudFormation, ejecuta el script `desplegar.sh`con permisos de superusuario como ya se indica:

```sh
./desplegar.sh
