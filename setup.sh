#!/bin/bash

# Hacer que el script falle si un comando falla
set -e

# Actualizar la lista de paquetes
echo "Actualizando la lista de paquetes..."
apt-get update

# Instalar aplicaciones necesarias
echo "Instalando wget y otros paquetes necesarios..."
apt-get install -y wget

# Preguntar al usuario si desea instalar gcc y g++
read -p "¿Desea instalar gcc y g++? [Y/N]: " respuesta

# Convertir la respuesta a minúsculas para manejar Y/y y N/n
respuesta=$(echo "$respuesta" | tr '[:upper:]' '[:lower:]')

# Verificar la respuesta del usuario
if [[ "$respuesta" == "y" || "$respuesta" == "yes" ]]; then
    echo "Instalando gcc y g++..."
    apt-get install -y gcc g++
    echo "gcc y g++ han sido instalados."
else
    echo "No se instalará gcc ni g++."
fi

# Preguntar al usuario si desea descargar Visual Studio Code
read -p "¿Desea descargar Visual Studio Code? [Y/N]: " respuesta_vscode

# Convertir la respuesta a minúsculas para manejar Y/y y N/n
respuesta_vscode=$(echo "$respuesta_vscode" | tr '[:upper:]' '[:lower:]')

# Verificar la respuesta del usuario para Visual Studio Code
if [[ "$respuesta_vscode" == "y" || "$respuesta_vscode" == "yes" ]]; then
    echo "Descargando Visual Studio Code..."
    wget "https://vscode.download.prss.microsoft.com/dbazure/download/stable/dc96b837cf6bb4af9cd736aa3af08cf8279f7685/code_1.89.1-1715060508_amd64.deb" -O /tmp/code_1.89.1-1715060508_amd64.deb
    echo "Instalando Visual Studio Code..."
    sudo dpkg -i /tmp/code_1.89.1-1715060508_amd64.deb
    sudo apt-get install -f -y  # Para corregir posibles dependencias faltantes
    echo "Visual Studio Code ha sido instalado."
else
    echo "No se descargará Visual Studio Code."
fi

# Preguntar al usuario si desea descargar Visual Studio Code
read -p "¿Desea descargar Logisim Evolution? [Y/N]: " respuesta_logisim

# Convertir la respuesta a minúsculas para manejar Y/y y N/n
respuesta_logisim=$(echo "$respuesta_logisim" | tr '[:upper:]' '[:lower:]')

# Verificar la respuesta del usuario para Visual Studio Code
if [[ "$respuesta_logisim" == "y" || "$respuesta_logisim" == "yes" ]]; then
    echo "Descargando Logisim Evolution..."
    wget https://github.com/logisim-evolution/logisim-evolution/releases/download/v3.7.2/logisim-evolution_3.7.2-1_amd64.deb
    echo "Instalando logisim..."
    sudo dpkg -i logisim-evolution_3.7.2-1_amd64.deb
    sudo apt-get install -f -y  # Para corregir posibles dependencias faltantes
    echo "Logisim se ha instalado correctamente."
else
    echo "No se descargará Logisim evolution."
fi

# Preguntar al usuario si desea descargar Visual Studio Code
read -p "¿Desea descargar Java? [Y/N]: " respuesta_java

# Convertir la respuesta a minúsculas para manejar Y/y y N/n
respuesta_java=$(echo "$respuesta_java" | tr '[:upper:]' '[:lower:]')

# Verificar la respuesta del usuario para Visual Studio Code
if [[ "$respuesta_java" == "y" || "$respuesta_java" == "yes" ]]; then
    echo "Descargando Java..."
    wget https://download.java.net/openjdk/jdk21/ri/openjdk-21+35_linux-x64_bin.tar.gz
    echo "Preparando para descomprimir el archivo descargado"
    tar -xvf openjdk-21+35_linux-x64_bin.tar.gz
    echo "Archivo descomprimido"
    echo "Ejecutando comandos extras"
    sudo mv jdk-21 /usr/local/
    export JAVA_HOME=/usr/local/jdk-21
    export PATH=$JAVA_HOME/bin:$PATH
    source ~/.bashrc
    java -version
    sudo apt -f install
    echo "Java descargado correctamente."
else
    echo "No se descargará Logisim evolution."
fi

# Limpieza
echo "Limpiando..."
apt-get clean

echo "Configuración post-instalación completada."
