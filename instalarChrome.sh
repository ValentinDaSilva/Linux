#!/usr/bin/env bash
set -euo pipefail

# Uso:
#   ./instalar_chrome_y_ajustar_ui.sh            # escala 1.25 por defecto
#   ./instalar_chrome_y_ajustar_ui.sh 1.5        # escala 1.5
#
# Requiere sudo para instalar el .deb

SCALE="${1:-1.25}"
DEB_URL="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
DEB_PATH="/tmp/google-chrome-stable_current_amd64.deb"
USER_DESKTOP_DIR="$HOME/.local/share/applications"
USER_DESKTOP_FILE="$USER_DESKTOP_DIR/google-chrome.desktop"
SYS_DESKTOP_FILE="/usr/share/applications/google-chrome.desktop"

echo ">>> Instalando dependencias básicas (wget, desktop-file-utils)..."
sudo apt update -y
sudo apt install -y wget desktop-file-utils

echo ">>> Descargando Chrome .deb..."
wget -qO "$DEB_PATH" "$DEB_URL"

echo ">>> Instalando Chrome..."
# Intento con dpkg y luego resuelvo dependencias si hiciera falta
if ! sudo dpkg -i "$DEB_PATH"; then
  echo ">>> Resolviendo dependencias faltantes..."
  sudo apt -f install -y
fi

# Aseguro que exista el .desktop del sistema (creado por el .deb)
if [ ! -f "$SYS_DESKTOP_FILE" ]; then
  echo "ERROR: No se encontró $SYS_DESKTOP_FILE. ¿Se instaló Chrome correctamente?" >&2
  exit 1
fi

echo ">>> Copiando lanzador a tu usuario para que no lo pisen las actualizaciones..."
mkdir -p "$USER_DESKTOP_DIR"
cp "$SYS_DESKTOP_FILE" "$USER_DESKTOP_FILE"

echo ">>> Inyectando --force-device-scale-factor=$SCALE en el lanzador..."
# 1) Limpiar cualquier flag previo de escala para evitar duplicados
sed -i -E 's/ --force-device-scale-factor=[0-9.]+//g' "$USER_DESKTOP_FILE"

# 2) Agregar la escala a TODAS las líneas Exec que lancen chrome
#    (línea principal y acciones como new-window / incognito)
sed -i -E "s#^Exec=/usr/bin/google-chrome-stable(.*)#Exec=/usr/bin/google-chrome-stable --force-device-scale-factor=${SCALE} \1#g" "$USER_DESKTOP_FILE"

# 3) Asegurar que la acción de incógnito conserve --incognito
#    (si ya estaba, se mantiene; si no, lo agregamos)
awk -v scale="$SCALE" '
  BEGIN { in_priv=0 }
  /^\[Desktop Action new-private-window\]/ { in_priv=1; print; next }
  /^\[/ && $0 !~ /\[Desktop Action new-private-window\]/ { in_priv=0; print; next }
  {
    if (in_priv && $0 ~ /^Exec=\/usr\/bin\/google-chrome-stable/) {
      if ($0 !~ /--incognito/) {
        sub(/%U|%u|%F|%f|$/, " --incognito &")
      }
    }
    print
  }
' "$USER_DESKTOP_FILE" > "$USER_DESKTOP_FILE.tmp" && mv "$USER_DESKTOP_FILE.tmp" "$USER_DESKTOP_FILE"

echo ">>> Actualizando base de accesos..."
update-desktop-database "$USER_DESKTOP_DIR" || true

echo ">>> Listo."
echo "Abrí Chrome desde el MENÚ de aplicaciones y debería verse con escala ${SCALE}."
echo
echo "Tips:"
echo " - Si querés cambiar la escala más tarde: volvés a correr el script con otro valor (ej: 1.5)."
echo " - Si usás Wayland y notás diferencias, podés probar además con:"
echo "     Exec=/usr/bin/google-chrome-stable --force-device-scale-factor=${SCALE} --ozone-platform-hint=auto %U"
