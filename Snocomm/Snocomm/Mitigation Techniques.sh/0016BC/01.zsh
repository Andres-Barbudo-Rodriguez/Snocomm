#
#  Snocomm
#
#  Created by Andres Barbudo on 12/21/23.
#  Copyright © 2023 Snocomm. All rights reserved.
#



# Script para mostrar información detallada sobre procesos

echo "Bienvenido al monitor de procesos"

# Obtener el nombre de usuario actual
usuario_actual=$(whoami)

# Mostrar la información general de los procesos del usuario actual
echo "Información general de procesos para el usuario $usuario_actual:"
ps aux --sort=-%cpu | grep $usuario_actual

# Pedir al usuario que ingrese el PID de un proceso para obtener detalles adicionales
read -p "Ingrese el PID del proceso que desea inspeccionar (0 para salir): " pid_ingresado

# Verificar si el usuario quiere salir
if [ "$pid_ingresado" -eq 0 ]; then
echo "Saliendo del monitor de procesos."
exit 0
fi

# Verificar si el PID ingresado es un número entero válido
if ! [[ "$pid_ingresado" =~ ^[0-9]+$ ]]; then
echo "Error: Ingrese un número entero válido como PID."
exit 1
fi

# Obtener detalles del proceso seleccionado
proceso_detalle=$(ps -p $pid_ingresado -o pid,ppid,pgid,cmd,%cpu,%mem,etime)

# Mostrar los detalles del proceso seleccionado
echo "Detalles del proceso con PID $pid_ingresado:"
echo "$proceso_detalle"

# Preguntar al usuario si desea ver más detalles
read -p "¿Desea ver más detalles sobre el proceso? (s/n): " opcion_detalle

# Verificar la respuesta del usuario
if [ "$opcion_detalle" = "s" ]; then
# Mostrar información adicional sobre el proceso
ps -p $pid_ingresado f
else
echo "Saliendo del monitor de procesos."
fi

exit 0
