#!/bin/bash

#######################################
# 1. Función copiar()
#######################################

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
      echo "🟡 La función 'copiar' ya existe en $archivo."
    else
      echo "⚙️ Agregando función copiar() en $archivo..."
      echo -e "\n# Función para copiar salida al portapapeles\n$FUNCION_COPIAR" >> "$archivo"
    fi
  else
    echo "⚠️ El archivo $archivo no existe."
  fi
}

agregar_funcion_si_no_existe "$HOME/.bashrc"
agregar_funcion_si_no_existe "$HOME/.zshrc"

#######################################
# 2. Selección del usuario en /home
#######################################

while true; do
    read -p "Ingrese el nombre del usuario: " nombre_usuario
    
    if [ -d "/home/$nombre_usuario" ]; then
        echo "El usuario '$nombre_usuario' existe."
        break
    else
        echo "El usuario '$nombre_usuario' no existe en /home. Intente nuevamente."
    fi
done

cd "/home/$nombre_usuario"

#######################################
# 3. Alias básicos
#######################################

echo "alias cl='clear'" >> .bashrc

#######################################
# 4. Actualización e instalación base
#######################################

echo "🔄 Actualizando lista de paquetes..."
apt-get update

echo "📦 Instalando paquetes básicos..."
apt-get install -y wget

#######################################
# 5. Instalar GCC y G++
#######################################

read -p "¿Desea instalar gcc y g++? [Y/N]: " respuesta
respuesta=$(echo "$respuesta" | tr '[:upper:]' '[:lower:]')

if [[ "$respuesta" == "y" || "$respuesta" == "yes" ]]; then
    echo "⚙️ Instalando gcc y g++..."
    apt-get install -y gcc g++
    echo "✔️ gcc y g++ instalados."
else
    echo "❌ No se instalarán gcc ni g++."
fi

#######################################
# 6. Instalar Visual Studio Code
#######################################

read -p "¿Desea descargar Visual Studio Code? [Y/N]: " respuesta_vscode
respuesta_vscode=$(echo "$respuesta_vscode" | tr '[:upper:]' '[:lower:]')

if [[ "$respuesta_vscode" == "y" || "$respuesta_vscode" == "yes" ]]; then
    echo "⬇️ Descargando Visual Studio Code..."
    wget "https://vscode.download.prss.microsoft.com/dbazure/download/stable/dc96b837cf6bb4af9cd736aa3af08cf8279f7685/code_1.89.1-1715060508_amd64.deb" -O /tmp/code.deb
    echo "⚙️ Instalando VS Code..."
    sudo dpkg -i /tmp/code.deb
    sudo apt-get install -f -y
    echo "✔️ VS Code instalado correctamente."
else
    echo "❌ No se instalará Visual Studio Code."
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
    echo 'alias logisim="/opt/logisim-evolution/bin/logisim-evolution"' >> .bashrc
    sudo apt-get install -f -y
    echo "✔️ Logisim Evolution instalado."
else
    echo "❌ No se instalará Logisim Evolution."
fi

#######################################
# 8. Logisim Clásico
#######################################

read -p "¿Desea descargar Logisim Clásico? [Y/N]: " respuesta_logisimClasico
respuesta_logisimClasico=$(echo "$respuesta_logisimClasico" | tr '[:upper:]' '[:lower:]')

if [[ "$respuesta_logisimClasico" == "y" || "$respuesta_logisimClasico" == "yes" ]]; then
    echo "⬇️ Descargando Logisim Clásico..."
    mkdir -p ~/.Logisim
    wget -O ~/.Logisim/logisim-generic-2.7.1.jar https://sourceforge.net/projects/circuit/files/latest/download
    echo 'alias logisim="java -jar ~/.Logisim/logisim-generic-2.7.1.jar"' >> .bashrc
    sudo apt-get install -f -y
    echo "✔️ Logisim clásico instalado."
else
    echo "❌ No se instalará Logisim clásico."
fi

#######################################
# 9. Java
#######################################

read -p "¿Desea instalar Java? [Y/N]: " respuesta_java
respuesta_java=$(echo "$respuesta_java" | tr '[:upper:]' '[:lower:]')

if [[ "$respuesta_java" == "y" || "$respuesta_java" == "yes" ]]; then
    echo "⬇️ Instalando Java..."
    apt-get install -y default-jdk
    echo "Versión instalada:"
    java --version
    sudo apt -f install -y
    echo "✔️ Java instalado correctamente."
else
    echo "❌ No se instalará Java."
fi

#######################################
# 10. Limpieza
#######################################

echo "🧹 Limpiando..."
apt-get clean

echo "🎉 Configuración completada exitosamente."
