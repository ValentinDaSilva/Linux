#!/bin/bash

#######################################
# 1. Preguntar si desea agregar copiar()
#    (SE AGREGA SOLO AL USUARIO ACTUAL)
#######################################

read -p "¿Desea agregar la función copiar() al usuario actual? [Y/N]: " respuesta_copiar
respuesta_copiar=$(echo "$respuesta_copiar" | tr '[:upper:]' '[:lower:]')

if [[ "$respuesta_copiar" == "y" || "$respuesta_copiar" == "yes" ]]; then

    FUNCION_COPIAR='copiar() {
  "$@" | xclip -selection clipboard
}'

    echo "🔍 Verificando si 'xclip' está instalado..."

    if ! command -v xclip &> /dev/null; then
        echo "❌ xclip no está instalado. Instalando..."
        sudo apt update && sudo apt install -y xclip
    else
        echo "✅ xclip ya está instalado."
    fi

    agregar_funcion_si_no_existe() {
      local archivo="$1"

      if [ -f "$archivo" ]; then
        if grep -q "copiar()" "$archivo"; then
          echo "🟡 La función copiar() ya existe en $archivo."
        else
          echo "⚙️ Agregando función copiar() en $archivo..."
          echo -e "\n# Función para copiar salida al portapapeles\n$FUNCION_COPIAR" >> "$archivo"
        fi
      else
        echo "⚠️ El archivo $archivo no existe."
      fi
    }

    # SE AGREGA AL USUARIO ACTUAL (NO AL DESTINO)
    agregar_funcion_si_no_existe "$HOME/.bashrc"
    agregar_funcion_si_no_existe "$HOME/.zshrc"

else
    echo "❌ No se agregará copiar()."
fi


#######################################
# 2. Elegir usuario de /home
#######################################

while true; do
    read -p "Ingrese el nombre del usuario al que quiere configurar: " nombre_usuario
    
    if [ -d "/home/$nombre_usuario" ]; then
        echo "El usuario '$nombre_usuario' existe."
        break
    else
        echo "❌ El usuario '$nombre_usuario' no existe en /home. Intente nuevamente."
    fi
done

TARGET_HOME="/home/$nombre_usuario"
TARGET_BASHRC="$TARGET_HOME/.bashrc"

#######################################
# 3. Alias SOLO para ese usuario
#######################################

echo "alias cl='clear'" >> "$TARGET_BASHRC"


#######################################
# 4. Actualización e instalación base
#######################################

echo "🔄 Actualizando lista de paquetes..."
apt-get update

echo "📦 Instalando wget..."
apt-get install -y wget

#######################################
# 5. GCC / G++
#######################################

read -p "¿Desea instalar gcc y g++? [Y/N]: " respuesta
respuesta=$(echo "$respuesta" | tr '[:upper:]' '[:lower:]')

if [[ "$respuesta" == "y" || "$respuesta" == "yes" ]]; then
    apt-get install -y gcc g++
    echo "✔️ gcc y g++ instalados."
else
    echo "❌ No se instalarán gcc ni g++."
fi

#######################################
# 6. Visual Studio Code
#######################################

read -p "¿Desea descargar Visual Studio Code? [Y/N]: " respuesta_vscode
respuesta_vscode=$(echo "$respuesta_vscode" | tr '[:upper:]' '[:lower:]')

if [[ "$respuesta_vscode" == "y" || "$respuesta_vscode" == "yes" ]]; then
    echo "⬇️ Descargando Visual Studio Code..."
    wget "https://vscode.download.prss.microsoft.com/dbazure/download/stable/dc96b837cf6bb4af9cd736aa3af08cf8279f7685/code_1.89.1-1715060508_amd64.deb" -O /tmp/code.deb
    echo "⚙️ Instalando VS Code..."
    sudo dpkg -i /tmp/code.deb
    sudo apt-get install -f -y
    echo "✔️ VS Code instalado."
else
    echo "❌ No se instalará VS Code."
fi

#######################################
# 7. Logisim Evolution
#######################################

read -p "¿Desea descargar Logisim Evolution? [Y/N]: " respuesta_logisimEvolution
respuesta_logisimEvolution=$(echo "$respuesta_logisimEvolution" | tr '[:upper:]' '[:lower:]')

if [[ "$respuesta_logisimEvolution" == "y" || "$respuesta_logisimEvolution" == "yes" ]]; then
    echo "⬇️ Descargando Logisim Evolution..."
    wget https://github.com/logisim-evolution/logisim-evolution/releases/download/v3.7.2/logisim-evolution_3.7.2-1_amd64.deb
    echo "⚙️ Instalando Logisim Evolution..."
    sudo dpkg -i logisim-evolution_3.7.2-1_amd64.deb
    echo 'alias logisim="/opt/logisim-evolution/bin/logisim-evolution"' >> "$TARGET_BASHRC"
    sudo apt-get install -f -y
    echo "✔️ Logisim Evolution instalado."
else
    echo "❌ No se instalará Logisim Evolution."
fi


#######################################
# 8. Logisim clásico
#######################################

read -p "¿Desea descargar Logisim Clásico? [Y/N]: " respuesta_logisimClasico
respuesta_logisimClasico=$(echo "$respuesta_logisimClasico" | tr '[:upper:]' '[:lower:]')

if [[ "$respuesta_logisimClasico" == "y" || "$respuesta_logisimClasico" == "yes" ]]; then
    echo "⬇️ Descargando Logisim Clásico..."
    mkdir -p "$TARGET_HOME/.Logisim"
    wget -O "$TARGET_HOME/.Logisim/logisim.jar" https://sourceforge.net/projects/circuit/files/latest/download
    echo 'alias logisim="java -jar ~/.Logisim/logisim.jar"' >> "$TARGET_BASHRC"
    sudo apt-get install -f -y
    echo "✔️ Logisim Clásico instalado."
else
    echo "❌ No se instalará Logisim Clásico."
fi


#######################################
# 9. Java
#######################################

read -p "¿Desea instalar Java? [Y/N]: " respuesta_java
respuesta_java=$(echo "$respuesta_java" | tr '[:upper:]' '[:lower:]')

if [[ "$respuesta_java" == "y" || "$respuesta_java" == "yes" ]]; then
    echo "⬇️ Instalando Java..."
    apt-get install -y default-jdk
    java --version
    echo "✔️ Java instalado."
else
    echo "❌ No se instalará Java."
fi

#######################################
# 11. Pharo (instalación en /opt)
#######################################

read -p "¿Desea descargar e instalar Pharo? [Y/N]: " respuesta_pharo
respuesta_pharo=$(echo "$respuesta_pharo" | tr '[:upper:]' '[:lower:]')

if [[ "$respuesta_pharo" == "y" || "$respuesta_pharo" == "yes" ]]; then

    echo "⬇️ Descargando Pharo Launcher..."
    cd /tmp || exit

    wget https://files.pharo.org/get-files/launcher/pharo-launcher-linux-3.4.3-x64.tar.gz -O pharo-launcher.tar.gz

    echo "📦 Descomprimiendo..."
    tar -xvzf pharo-launcher.tar.gz

    echo "📁 Moviendo a /opt..."
    sudo rm -rf /opt/pharo-launcher
    sudo mv pharo-launcher /opt/pharo-launcher

    echo "🔗 Creando comando global..."
    sudo ln -sf /opt/pharo-launcher/pharo-launcher-ui /usr/local/bin/pharo-ui

    #######################################
    # Alias para el usuario elegido
    #######################################

    TARGET_HOME="/home/$nombre_usuario"
    TARGET_BASHRC="$TARGET_HOME/.bashrc"

    echo "⚙️ Configurando alias 'pharo' para $nombre_usuario..."

    if ! grep -q "alias pharo=" "$TARGET_BASHRC"; then
        echo "alias pharo='pharo-ui &'" >> "$TARGET_BASHRC"
        echo "✔️ Alias agregado."
    else
        echo "🟡 El alias ya existe."
    fi

    echo "✔️ Pharo instalado correctamente."
    echo "💡 El usuario '$nombre_usuario' puede ejecutar: pharo"

else
    echo "❌ No se instalará Pharo."
fi

#######################################
# 10. Limpieza final
#######################################

echo "🧹 Limpiando..."
apt-get clean

echo "🎉 Configuración completada exitosamente."
