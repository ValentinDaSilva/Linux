#!/bin/bash

# Función para verificar si un comando está instalado
comando_instalado() {
  command -v "$1" &> /dev/null
}

# Instalar las herramientas necesarias si no están instaladas
instalar_herramientas() {
  if ! comando_instalado "convert"; then
    echo "ImageMagick no está instalado. Instalando..."
    sudo apt-get update
    sudo apt-get install -y imagemagick
  fi

  if ! comando_instalado "img2pdf"; then
    echo "img2pdf no está instalado. Instalando..."
    sudo apt-get install -y img2pdf
  fi

  if ! comando_instalado "pdftoppm"; then
    echo "poppler-utils (pdftoppm) no está instalado. Instalando..."
    sudo apt-get install -y poppler-utils
  fi
}

# Función para convertir un PDF a imágenes
convertirPdfAImg() {
  local ubicacionDelArchivo="$1"
  if [[ -f "$ubicacionDelArchivo" ]]; then
    echo "Convirtiendo PDF $ubicacionDelArchivo a imágenes..."
    pdftoppm "$ubicacionDelArchivo" "${ubicacionDelArchivo%.*}" -png
    echo "Conversión completada: imágenes guardadas como ${ubicacionDelArchivo%.*}-1.png, ${ubicacionDelArchivo%.*}-2.png, etc."
  else
    echo "El archivo $ubicacionDelArchivo no existe o no es válido."
  fi
}

# Función para convertir una imagen a PDF
convertirImgAPdf() {
  local ubicacionArchivo="$1"
  if [[ -f "$ubicacionArchivo" ]]; then
    echo "Convirtiendo imagen $ubicacionArchivo a PDF..."
    convert "$ubicacionArchivo" "${ubicacionArchivo%.*}.pdf"
    echo "Conversión completada: ${ubicacionArchivo%.*}.pdf"
  else
    echo "El archivo $ubicacionArchivo no existe o no es válido."
  fi
}

# Función para agregar las funciones al .bashrc y .zshrc (si existe)
agregar_a_bashrc_y_zshrc() {
  echo "Agregando funciones al archivo ~/.bashrc y ~/.zshrc (si existe)..."

  # Definir las funciones que se agregarán
  FUNCIONES='
# Función para convertir un PDF a imágenes
convertirPdfAImg() {
  local ubicacionDelArchivo="$1"
  if [[ -f "$ubicacionDelArchivo" ]]; then
    echo "Convirtiendo PDF $ubicacionDelArchivo a imágenes..."
    pdftoppm "$ubicacionDelArchivo" "${ubicacionDelArchivo%.*}" -png
    echo "Conversión completada: imágenes guardadas como ${ubicacionDelArchivo%.*}-1.png, ${ubicacionDelArchivo%.*}-2.png, etc."
  else
    echo "El archivo $ubicacionDelArchivo no existe o no es válido."
  fi
}

# Función para convertir una imagen a PDF
convertirImgAPdf() {
  local ubicacionArchivo="$1"
  if [[ -f "$ubicacionArchivo" ]]; then
    echo "Convirtiendo imagen $ubicacionArchivo a PDF..."
    convert "$ubicacionArchivo" "${ubicacionArchivo%.*}.pdf"
    echo "Conversión completada: ${ubicacionArchivo%.*}.pdf"
  else
    echo "El archivo $ubicacionArchivo no existe o no es válido."
  fi
}
'

  # Agregar a .bashrc
  echo "$FUNCIONES" >> ~/.bashrc
  echo "Funciones agregadas a ~/.bashrc"

  # Agregar a .zshrc si existe
  if [[ -f ~/.zshrc ]]; then
    echo "$FUNCIONES" >> ~/.zshrc
    echo "Funciones agregadas a ~/.zshrc"
  else
    echo "~/.zshrc no encontrado, no se agregaron las funciones."
  fi
}

# Instalar las herramientas necesarias
instalar_herramientas

# Llamamos a la función para agregar las funciones al .bashrc y .zshrc
agregar_a_bashrc_y_zshrc

echo "Funciones agregadas a ~/.bashrc y ~/.zshrc (si existe). Ahora debes recargar los archivos con 'source ~/.bashrc' y 'source ~/.zshrc' si usas Zsh."
