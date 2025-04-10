#!/bin/bash

# Nombre de la función
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

# Función para agregar la función al archivo si no existe
agregar_funcion_si_no_existe() {
  local archivo="$1"
  local nombre_funcion="copiar"

  if [ -f "$archivo" ]; then
    if grep -q "copiar()" "$archivo"; then
      echo "🟡 La función 'copiar' ya existe en $archivo, no se agrega."
    else
      echo "✅ Agregando función 'copiar' a $archivo..."
      echo -e "\n# Función para copiar salida al portapapeles\n$FUNCION_COPIAR" >> "$archivo"
    fi
  else
    echo "⚠️ El archivo $archivo no existe. No se modifica."
  fi
}

# Agregar a ~/.bashrc y ~/.zshrc si existen
agregar_funcion_si_no_existe "$HOME/.bashrc"
agregar_funcion_si_no_existe "$HOME/.zshrc"

echo "✅ Todo listo. Recargá tu terminal o ejecutá 'source ~/.bashrc' o 'source ~/.zshrc' para usar la función."
