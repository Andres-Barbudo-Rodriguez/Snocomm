

#  02.sh
#  Snocomm
#
#  Created by Andres Barbudo on 12/21/23.
#  Copyright © 2023 Snocomm. All rights reserved.



# Script para obtener información detallada sobre los archivos abiertos por un proceso

echo "Bienvenido al monitor de archivos abiertos por proceso"

# Pedir al usuario que ingrese el PID del proceso
read -p "Ingrese el PID del proceso para el cual desea ver los archivos abiertos: " pid_ingresado

# Verificar si el PID ingresado es un número entero válido
if ! [[ "$pid_ingresado" =~ ^[0-9]+$ ]]; then
echo "Error: Ingrese un número entero válido como PID."
exit 1
fi

# Utilizar lsof para obtener información sobre los archivos abiertos por el proceso
archivos_abiertos=$(lsof -p $pid_ingresado)

# Verificar si hay archivos abiertos por el proceso
if [ -z "$archivos_abiertos" ]; then
echo "No se encontraron archivos abiertos por el proceso con PID $pid_ingresado."
exit 0
fi

# Mostrar información detallada sobre los archivos abiertos
echo "Archivos abiertos por el proceso con PID $pid_ingresado:"
echo "$archivos_abiertos"

# Preguntar al usuario si desea ver más detalles sobre un archivo específico
read -p "¿Desea ver más detalles sobre un archivo específico? (s/n): " opcion_detalle

# Verificar la respuesta del usuario
if [ "$opcion_detalle" = "s" ]; then
# Pedir al usuario que ingrese el nombre del archivo para obtener más detalles
read -p "Ingrese el nombre del archivo que desea inspeccionar: " archivo_ingresado

# Utilizar lsof para obtener detalles adicionales sobre el archivo seleccionado
detalles_archivo=$(lsof -p $pid_ingresado | grep "$archivo_ingresado")

# Mostrar detalles adicionales sobre el archivo seleccionado
echo "Detalles del archivo $archivo_ingresado:"
echo "$detalles_archivo"
else
echo "Saliendo del monitor de archivos abiertos por proceso."
fi

exit 0
