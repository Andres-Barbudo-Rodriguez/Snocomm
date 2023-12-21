
#  03.zsh
#  Snocomm
#
#  Created by Andres Barbudo on 12/21/23.
#  Copyright © 2023 Snocomm. All rights reserved.



# Script para capturar y analizar el tráfico de red con tcpdump

# Verificar si el usuario tiene privilegios de superusuario
if [[ $EUID -ne 0 ]]; then
echo "Este script debe ejecutarse con privilegios de superusuario para utilizar tcpdump."
exit 1
fi

echo "Bienvenido al script de captura y análisis de tráfico de red con tcpdump"

# Pedir al usuario que seleccione una interfaz de red
read -p "Ingrese el nombre de la interfaz de red que desea monitorear (por ejemplo, eth0): " interfaz

# Pedir al usuario que especifique un filtro BPF (Berkeley Packet Filter)
read -p "Ingrese un filtro BPF para capturar el tráfico (deje en blanco para capturar todo el tráfico): " filtro_bpf

# Pedir al usuario que especifique un nombre de archivo para guardar la captura
read -p "Ingrese el nombre del archivo para guardar la captura (deje en blanco para mostrar en la consola): " archivo_salida

# Configurar el comando tcpdump con la interfaz, filtro y archivo de salida especificados
comando_tcpdump="tcpdump -i $interfaz $filtro_bpf"

# Redirigir la salida de tcpdump al archivo especificado si se proporciona
if [ -n "$archivo_salida" ]; then
comando_tcpdump="$comando_tcpdump -w $archivo_salida"
fi

# Mostrar el comando tcpdump configurado y pedir confirmación al usuario
echo "El comando tcpdump configurado es:"
echo "$comando_tcpdump"

read -p "Presione Enter para comenzar la captura de tráfico..."

# Ejecutar tcpdump con las configuraciones proporcionadas
$comando_tcpdump

echo "Captura de tráfico completada. Saliendo del script."
exit 0
