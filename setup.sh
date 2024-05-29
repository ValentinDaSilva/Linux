#!/bin/bash

# Hacer que el script falle si un comando falla
set -e

# Actualizar la lista de paquetes
echo "Actualizando la lista de paquetes..."
apt-get update

# Instalar aplicaciones necesarias
echo "Instalando wget y otros paquetes necesarios..."
apt-get install -y wget

#!/bin/bash

# Preguntar al usuario si desea descargar Visual Studio Code
read -p "¿Desea descargar Visual Studio Code? [Y/N]: " respuesta

# Convertir la respuesta a minúsculas para manejar Y/y y N/n
respuesta=$(echo "$respuesta" | tr '[:upper:]' '[:lower:]')

# Verificar la respuesta del usuario
if [[ "$respuesta" == "y" || "$respuesta" == "yes" ]]; then
    echo "Descargando Visual Studio Code..."
    wget "https://vscode.download.prss.microsoft.com/dbazure/download/stable/dc96b837cf6bb4af9cd736aa3af08cf8279f7685/code_1.89.1-1715060508_amd64.deb" -O /tmp/code_1.89.1-1715060508_amd64.deb
    echo "Instalando Visual Studio Code..."
    sudo dpkg -i /tmp/code_1.89.1-1715060508_amd64.deb
    sudo apt-get install -f -y  # Para corregir posibles dependencias faltantes
    echo "Visual Studio Code ha sido instalado."
else
    echo "No se descargará Visual Studio Code."
fi
# Limpieza
echo "Limpiando..."
apt-get clean

echo "Configuración post-instalación completada."
