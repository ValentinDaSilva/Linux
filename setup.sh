#!/bin/bash

# Hacer que el script falle si un comando falla
set -e

# Actualizar la lista de paquetes
echo "Actualizando la lista de paquetes..."
apt-get update

# Instalar aplicaciones necesarias
echo "Instalando wget y otros paquetes necesarios..."
apt-get install -y wget

# Descargar el archivo .deb de Visual Studio Code
echo "Descargando Visual Studio Code..."
wget "https://vscode.download.prss.microsoft.com/dbazure/download/stable/dc96b837cf6bb4af9cd736aa3af08cf8279f7685/code_1.89.1-1715060508_amd64.deb" -O /tmp/code_1.89.1-1715060508_amd64.deb

# Instalar el archivo .deb de Visual Studio Code
echo "Instalando Visual Studio Code..."
dpkg -i /tmp/code_1.89.1-1715060508_amd64.deb

# Corregir dependencias si es necesario
echo "Corrigiendo dependencias..."
apt-get install -f -y

# Limpieza
echo "Limpiando..."
apt-get clean

echo "Configuración post-instalación completada."
