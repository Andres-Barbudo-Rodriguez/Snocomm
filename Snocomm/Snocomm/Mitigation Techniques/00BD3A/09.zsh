

#  09.zsh
#  Snocomm
#
#  Created by Andres Barbudo on 12/21/23.
#  Copyright © 2023 Snocomm. All rights reserved.



# Script para mostrar y modificar parámetros del kernel con el comando sysctl

echo "Bienvenido al script de gestión de parámetros del kernel con sysctl"

# Mostrar información sobre el sistema
echo "Información del sistema:"
sysctl -a

# Pedir al usuario que seleccione un parámetro para modificar
read -p "Ingrese el nombre del parámetro del kernel que desea modificar (deje en blanco para omitir): " parametro_modificar

# Verificar si el usuario ingresó un parámetro para modificar
if [ -n "$parametro_modificar" ]; then
# Pedir al usuario el nuevo valor para el parámetro
read -p "Ingrese el nuevo valor para $parametro_modificar: " nuevo_valor

# Modificar el parámetro del kernel
sysctl -w $parametro_modificar=$nuevo_valor
echo "Parámetro modificado correctamente."
fi

echo "Saliendo del script."
exit 0
