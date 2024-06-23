#!/bin/bash

# Actualizar la lista de paquetes
echo "agregando alias al sistema"
echo 'alias cl="clear"' >> ~/.bashrc
source ~/.bashrc


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
read -p "¿Desea descargar Logisim Evolution? [Y/N]: " respuesta_logisimEvolution

# Convertir la respuesta a minúsculas para manejar Y/y y N/n
respuesta_logisimEvolution=$(echo "$respuesta_logisimEvolution" | tr '[:upper:]' '[:lower:]')

# Verificar la respuesta del usuario para Visual Studio Code
if [[ "$respuesta_logisimEvolution" == "y" || "$respuesta_logisimEvolution" == "yes" ]]; then
    echo "Descargando Logisim Evolution..."
    wget https://github.com/logisim-evolution/logisim-evolution/releases/download/v3.7.2/logisim-evolution_3.7.2-1_amd64.deb
    echo "Instalando logisim..."
    sudo dpkg -i logisim-evolution_3.7.2-1_amd64.deb
    echo 'alias logisim="/opt/logisim-evolution/bin/logisim-evolution"' >> ~/.bashrc
    source ~/.bashrc
    sudo apt-get install -f -y  # Para corregir posibles dependencias faltantes
    echo "Logisim se ha instalado correctamente."
else
    echo "No se descargará Logisim evolution."
fi

read -p "¿Desea descargar Logisim Clasico? [Y/N]: " respuesta_logisimClasico

# Convertir la respuesta a minúsculas para manejar Y/y y N/n
respuesta_logisimClasico=$(echo "$respuesta_logisimClasico" | tr '[:upper:]' '[:lower:]')

# Verificar la respuesta del usuario para Visual Studio Code
if [[ "$respuesta_logisimClasico" == "y" || "$respuesta_logisimClasico" == "yes" ]]; then
    echo "Descargando Logisim Clasico..."
    mkdir ~/.Logisim
    wget -O ~/.Logisim/logisim-generic-2.7.1.jar https://sourceforge.net/projects/circuit/files/latest/download
    sudo apt-get install -f -y  # Para corregir posibles dependencias faltantes
    alias logisim="java -jar ~/.Logisim/logisim-generic-2.7.1.jar"
    echo "Logisim se ha instalado correctamente."
    echo "La carpeta en la que se guardo fue en ~/.Logisim"
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
    apt-get install default-jdk
    java --version
    sudo apt -f install
    echo "Java descargado correctamente."
else
    echo "No se descargará Logisim evolution."
fi

# Limpieza
echo "Limpiando..."
apt-get clean

echo "Configuración post-instalación completada."
