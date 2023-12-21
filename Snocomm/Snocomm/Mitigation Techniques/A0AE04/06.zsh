

#  06.zsh
#  Snocomm
#
#  Created by Andres Barbudo on 12/21/23.
#  Copyright © 2023 Snocomm. All rights reserved.


# Script para mostrar y manipular la tabla de enrutamiento con el comando route

echo "Bienvenido al script de gestión de la tabla de enrutamiento con route"

# Mostrar la tabla de enrutamiento actual
echo "Tabla de enrutamiento actual:"
route -n

# Pedir al usuario que seleccione una opción
echo "Opciones:"
echo "1. Agregar una ruta"
echo "2. Eliminar una ruta"
echo "3. Salir"
read -p "Seleccione una opción (1/2/3): " opcion

case $opcion in
1)
# Agregar una nueva ruta
read -p "Ingrese la red de destino (en formato CIDR, por ejemplo, 192.168.1.0/24): " red_destino
read -p "Ingrese la puerta de enlace (Gateway): " puerta_enlace

# Agregar la ruta
route add -net $red_destino gw $puerta_enlace
echo "Ruta agregada correctamente."
;;
2)
# Eliminar una ruta existente
read -p "Ingrese la red de destino a eliminar (en formato CIDR, por ejemplo, 192.168.1.0/24): " red_destino_eliminar

# Eliminar la ruta
route del -net $red_destino_eliminar
echo "Ruta eliminada correctamente."
;;
3)
# Salir del script
echo "Saliendo del script."
exit 0
;;
*)
# Opción no válida
echo "Opción no válida. Saliendo del script."
exit 1
;;
esac

# Mostrar la tabla de enrutamiento actualizada
echo "Tabla de enrutamiento actualizada:"
route -n

echo "Saliendo del script."
exit 0
