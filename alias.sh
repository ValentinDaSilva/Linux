echo 'alias cl="clear"' >> ~/.bashrc
echo 'alias push="git add . && git commit -m \"Commit automatico\" && git push origin main"' >> ~/.bashrc
echo 'alias logisim="/opt/logisim-evolution/bin/logisim-evolution"' >> ~/.bashrc
source ~/.bashrc


#Mas Adelante

# Definir variables de color
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # Sin color
# Definir variables de color en español
ROJO='\033[0;31m'
VERDE='\033[0;32m'
AMARILLO='\033[1;33m'
AZUL='\033[0;34m'
NINGUNO='\033[0m' # Sin color


alias cl="clear"
alias pushArquitectura="cd /home/valedasilvacatelavdc/Arquitectura/ && git add . && git commit -m \"Commit automatico\" && git push origin main"
alias pushArq="pushAquitectura"
alias logisim="java -jar ~/.Logisim/logisim-generic-2.7.1.jar"
alias lr="ls -1"
alias descomprimir="tar -xzvf"

push() {
    echo "Selecciona una opción:"
    echo "1. pushArquitectura"
    echo "2. pushAlgoritmos"
    read -p "Introduce el número de tu elección: " choice
    
    case $choice in
        1)
            echo "Ejecutando comandos para pushArquitectura..."
            # Aquí puedes añadir los comandos que quieres ejecutar para pushArquitectura
            cd /home/valedasilvacatelavdc/Arquitectura/ && git add . && git commit -m "Commit automatico" && git push origin main
				echo "${VERDE}Listo, push hecho para arquitectura"
            ;;
        2)
            echo "Ejecutando comandos para pushAlgoritmos..."
            # Aquí puedes añadir los comandos que quieres ejecutar para pushAlgoritmos
            cd /home/valedasilvacatelavdc/Algoritmos-Y-Estructuras-De-Datos/ && git add . && git commit -m "Commit automatico" && git push origin main
				echo "${VERDE}Listo, push hecho para algoritmos"
            ;;
        *)
            echo "${ROJO}Opción no válida"
            ;;
    esac
}
