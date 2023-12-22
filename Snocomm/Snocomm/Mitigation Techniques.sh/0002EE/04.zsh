

#  04.zsh
#  Snocomm
#
#  Created by Andres Barbudo on 12/21/23.
#  Copyright © 2023 Snocomm. All rights reserved.



# Script para mostrar información detallada sobre interfaces de red con ifconfig

echo "Bienvenido al script de información de interfaces de red con ifconfig"

# Pedir al usuario que seleccione una interfaz de red
read -p "Ingrese el nombre de la interfaz de red que desea consultar (por ejemplo, eth0): " interfaz

# Verificar si la interfaz ingresada existe
if ! ifconfig $interfaz > /dev/null 2>&1; then
echo "Error: La interfaz $interfaz no existe."
exit 1
fi

# Mostrar información detallada sobre la interfaz de red seleccionada
echo "Información detallada sobre la interfaz de red $interfaz:"
ifconfig $interfaz

# Preguntar al usuario si desea ver estadísticas detalladas
read -p "¿Desea ver estadísticas detalladas para la interfaz $interfaz? (s/n): " opcion_estadisticas

# Verificar la respuesta del usuario
if [ "$opcion_estadisticas" = "s" ]; then
# Mostrar estadísticas detalladas de la interfaz
echo "Estadísticas detalladas para la interfaz $interfaz:"
ifconfig $interfaz | grep "RX\|TX"
fi

echo "Saliendo del script."
exit 0
