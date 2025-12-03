#!/bin/bash

#######################################
# 1. Elegir usuario de /home
#######################################

while true; do
    read -p "Ingrese el nombre del usuario a configurar: " nombre_usuario
    
    if [ -d "/home/$nombre_usuario" ]; then
        echo "✔ Usuario '$nombre_usuario' encontrado."
        break
    else
        echo "❌ No existe en /home. Intente nuevamente."
    fi
done

TARGET_HOME="/home/$nombre_usuario"
TARGET_BASHRC="$TARGET_HOME/.bashrc"


#######################################
# 2. Preguntar si desea agregar copiar()
#######################################

read -p "¿Desea agregar la función copiar() a $nombre_usuario? [Y/N]: " respuesta_copiar
respuesta_copiar=$(echo "$respuesta_copiar" | tr '[:upper:]' '[:lower:]')

if [[ "$respuesta_copiar" == "y" || "$respuesta_copiar" == "yes" ]]; then

    FUNCION_COPIAR='copiar() {
  "$@" | xclip -selection clipboard
}'

    echo "🔍 Verificando si xclip está instalado..."
    if ! command -v xclip &> /dev/null; then
        sudo apt update && sudo apt install -y xclip
    fi

    if ! grep -q "copiar()" "$TARGET_BASHRC" 2>/dev/null; then
        echo -e "\n# Función para copiar salida al portapapeles\n$FUNCION_COPIAR" >> "$TARGET_BASHRC"
        echo "✔ copiar() agregada a $TARGET_BASHRC"
    else
        echo "🟡 La función copiar() ya existe en ese bashrc."
    fi

else
    echo "❌ No se agregará copiar()."
fi


#######################################
# 3. Agregar alias básicos al usuario elegido
#######################################

echo "alias cl='clear'" >> "$TARGET_BASHRC"


#######################################
# 4. Actualización e instalación base
#######################################

echo "🔄 Actualizando paquetes..."
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
    echo "✔ gcc y g++ instalados."
fi


#######################################
# 6. Visual Studio Code
#######################################

read -p "¿Desea descargar Visual Studio Code? [Y/N]: " r
r=$(echo "$r" | tr '[:upper:]' '[:lower:]')
if [[ "$r" == "y" || "$r" == "yes" ]]; then
    echo "⬇️ Descargando Visual Studio Code..."
    wget -O /tmp/code.deb "https://vscode.download.prss.microsoft.com/dbazure/download/stable/dc96b837cf6bb4af9cd736aa3af08cf8279f7685/code_1.89.1-1715060508_amd64.deb"
    sudo dpkg -i /tmp/code.deb
    sudo apt-get install -f -y
    echo "✔ VS Code instalado."
fi


#######################################
# 7. Logisim Evolution
#######################################

read -p "¿Desea instalar Logisim Evolution? [Y/N]: " re
re=$(echo "$re" | tr '[:upper:]' '[:lower:]')
if [[ "$re" == "y" || "$re" == "yes" ]]; then
    echo "⬇️ Descargando Logisim Evolution..."
    wget https://github.com/logisim-evolution/logisim-evolution/releases/download/v3.7.2/logisim-evolution_3.7.2-1_amd64.deb
    sudo dpkg -i logisim-evolution_3.7.2-1_amd64.deb
    echo 'alias logisim="/opt/logisim-evolution/bin/logisim-evolution"' >> "$TARGET_BASHRC"
    sudo apt-get install -f -y
    echo "✔ Logisim Evolution instalado."
fi


#######################################
# 8. Logisim clásico
#######################################

read -p "¿Desea descargar Logisim Clásico? [Y/N]: " rc
rc=$(echo "$rc" | tr '[:upper:]' '[:lower:]')
if [[ "$rc" == "y" || "$rc" == "yes" ]]; then
    echo "⬇️ Descargando Logisim Clásico..."
    mkdir -p "$TARGET_HOME/.Logisim"
    wget -O "$TARGET_HOME/.Logisim/logisim.jar" https://sourceforge.net/projects/circuit/files/latest/download
    echo 'alias logisim="java -jar ~/.Logisim/logisim.jar"' >> "$TARGET_BASHRC"
    sudo apt-get install -f -y
    echo "✔ Logisim Clásico instalado."
fi


#######################################
# 9. Java
#######################################

read -p "¿Desea instalar Java? [Y/N]: " rj
rj=$(echo "$rj" | tr '[:upper:]' '[:lower:]')
if [[ "$rj" == "y" || "$rj" == "yes" ]]; then
    echo "⬇️ Instalando Java..."
    apt-get install -y default-jdk
    java --version
    echo "✔ Java instalado."
fi
#######################################
# Instalar TREE + agregar reels() y alias ls
#######################################

read -p "¿Desea instalar 'tree' y agregar la función reels()? [Y/N]: " resp_tree
resp_tree=$(echo "$resp_tree" | tr '[:upper:]' '[:lower:]')

if [[ "$resp_tree" == "y" || "$resp_tree" == "yes" ]]; then

    echo "📦 Instalando tree..."
    apt-get install -y tree

    FUNCION_REELS='treels() {
    if [ $# -eq 0 ]; then
        tree -L 1
        return
    fi

    if [[ "$1" =~ ^[0-9]+$ ]]; then
        tree -L "$1"
        return
    fi

    ls "$@"
}'

    # Agregar la función reels() al bashrc del usuario elegido
    if ! grep -q "treels()" "$TARGET_BASHRC" 2>/dev/null; then
        echo -e "\n# Función reels para tree/ls inteligente\n$FUNCION_REELS" >> "$TARGET_BASHRC"
        echo "✔ Función reels() agregada a $TARGET_BASHRC"
    else
        echo "🟡 La función treels() ya existe en ese bashrc."
    fi

    # Agregar alias ls="reels"
    if ! grep -q "alias ls='treels'" "$TARGET_BASHRC" 2>/dev/null; then
        echo "alias ls='treels'" >> "$TARGET_BASHRC"
        echo "✔ Alias ls='treels' agregado."
    else
        echo "🟡 El alias ls='treels' ya existe."
    fi

else
    echo "❌ No se instalará tree ni se agregará treels()."
fi


#######################################
# 10. Limpieza final
#######################################

echo "🧹 Limpiando..."
apt-get clean

echo "🎉 Configuración completada exitosamente."
