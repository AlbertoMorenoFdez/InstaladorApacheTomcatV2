#!/bin/bash

# Verificamos y actualizamos el sistema
apt update -y
apt upgrade -y

# Instalamos Java JDK y verificamos la instalación
sudo apt install openjdk-17-jdk
sudo apt install openjdk-17-jre

# Creamos un usuario y un grupo tomcat si no existen
echo "Creando el usuario tomcat."
if id "tomcat" >/dev/null 2>&1; then
    echo "El usuario tomcat ya existe."
else
    useradd -m -d /opt/tomcat -U -s /bin/false tomcat
fi

echo "Creando el grupo TomcatGroup."
if getent group "TomcatGroup" >/dev/null 2>&1; then
    echo "Grupo TomcatGroup ya existe"
else
    groupadd TomcatGroup
fi
# Asociamos el usuario tomcat al grupo TomcatGroup
usermod -aG TomcatGroup tomcat

# Descargamos Apache Tomcat desde el sitio oficial y verificamos dicha descarga
wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.18/bin/apache-tomcat-10.1.18.tar.gz

# Mostramos un mensaje de error y terminamos el script si no se pudo descargar Apache Tomcat
if [ ! -f apache-tomcat-10.1.18.tar.gz ]; then
    echo "Error: No se pudo descargar Apache Tomcat."
    exit 1
fi

# Creamos el directorio de instalación
mkdir -p /opt/tomcat

# Descomprimimos Apache Tomcat en el directorio de instalación
tar xzvf apache-tomcat-10.1.18.tar.gz -C /opt/tomcat --strip-components=1

# Cambiamos el propietario y los permisos del directorio de instalación
chown -R tomcat:TomcatGroup /opt/tomcat
chmod -R u+x /opt/tomcat/bin

# Configuramos usuarios administradores añadiendo roles y usuarios a tomcat-users.xml
sed -i '/<\/tomcat-users>/i \  <role rolename="manager-gui" \/>\n  <user username="manager" password="1234" roles="manager-gui" \/>\n  <role rolename="admin-gui" \/>\n  <user username="admin" password="1234" roles="manager-gui,admin-gui" \/>' /opt/tomcat/conf/tomcat-users.xml

# Eliminamos las restricciones por defecto
# Comentamos la etiqueta Valve en context.xml
sed -i '/<Valve className="org.apache.catalina.valves.RemoteAddrValve"/, /allow="127\\.\d+\\.\d+\\.\d+\|::1\|0:0:0:0:0:0:0:1" \/>/ s/^/<!-- /; s/$/ -->/' /opt/tomcat/webapps/manager/META-INF/context.xml

# Y Comentamos la etiqueta Valve en context.xml de host-manager
sed -i '/<Valve className="org.apache.catalina.valves.RemoteAddrValve"/, /allow="127\\.\d+\\.\d+\\.\d+\|::1\|0:0:0:0:0:0:0:1" \/>/ s/^/<!-- /; s/$/ -->/' /opt/tomcat/webapps/host-manager/META-INF/context.xml

# Listamos los archivos a verificar antes de modificarlos
files_to_check=(
    "/opt/tomcat/conf/tomcat-users.xml"
    "/opt/tomcat/webapps/manager/META-INF/context.xml"
    "/opt/tomcat/webapps/host-manager/META-INF/context.xml"
)

# Si no se encuentra el archivo, imprimimos un mensaje de error y se termina el script
for file in "${files_to_check[@]}"; do
    if [ ! -f "$file" ]; then
        echo "Error: No se encontró el archivo $file."
        exit 1
    fi
done

# Creamos el archivo de servicio Tomcat y añadimos la configuración
# Este archivo define cómo systemd manejará el servicio de Tomcat
sudo bash -c 'cat > /etc/systemd/system/tomcat.service' <<-'EOF'
[Unit]
Description=Tomcat
After=network.target

[Service]
Type=forking

User=tomcat
Group=tomcat

Environment="JAVA_HOME=/usr/lib/jvm/java-1.11.0-openjdk-amd64"
Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom"
Environment="CATALINA_BASE=/opt/tomcat"
Environment="CATALINA_HOME=/opt/tomcat"
Environment="CATALINA_PID=/opt/tomcat/temp/tomcat.pid"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Establecemos permisos de lectura para todos los usuarios al archivo del servicio
# Necesario para que systemd pueda leer el archivo
sudo chmod 644 /etc/systemd/system/tomcat.service

# Obtenemos la ruta de instalación de Java 1.17.0
JAVA_PATH=$(sudo update-java-alternatives -l | grep '1.17.0' | awk '{print $3}')

# Reemplazamos JAVA_HOME en tomcat.service con la ruta obtenida
sudo sed -i "s|JAVA_HOME=/usr/lib/jvm/java-1.11.0-openjdk-amd64|JAVA_HOME=$JAVA_PATH|g" /etc/systemd/system/tomcat.service

# Recargamos la configuración de systemd para que reconozca el nuevo servicio
# Iniciamos el servicio de Tomcat y configurarloconfiguramos para que se inicie automáticamente en el arranque
sudo systemctl daemon-reload
sudo systemctl start tomcat
sudo systemctl enable tomcat
