

#  07.zsh
#  Snocomm
#
#  Created by Andres Barbudo on 12/21/23.
#  Copyright © 2023 Snocomm. All rights reserved.



# Script para mostrar información detallada sobre conexiones de red con el comando netstat

echo "Bienvenido al script de información de conexiones de red con netstat"

# Mostrar las conexiones de red actuales
echo "Conexiones de red actuales:"
netstat -tuln

# Mostrar la tabla de enrutamiento
echo "Tabla de enrutamiento:"
netstat -r

# Mostrar estadísticas de interfaces
echo "Estadísticas de interfaces:"
netstat -i

# Preguntar al usuario si desea ver estadísticas extendidas
read -p "¿Desea ver estadísticas extendidas? (s/n): " opcion_estadisticas_extendidas

# Verificar la respuesta del usuario
if [ "$opcion_estadisticas_extendidas" = "s" ]; then
# Mostrar estadísticas extendidas
echo "Estadísticas extendidas:"
netstat -s
fi

# Preguntar al usuario si desea ver el estado de la pila de red
read -p "¿Desea ver el estado de la pila de red? (s/n): " opcion_estado_pila

# Verificar la respuesta del usuario
if [ "$opcion_estado_pila" = "s" ]; then
# Mostrar el estado de la pila de red
echo "Estado de la pila de red:"
netstat -a
fi

echo "Saliendo del script."
exit 0
