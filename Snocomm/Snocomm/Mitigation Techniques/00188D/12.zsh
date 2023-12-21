

#  12.zsh
#  Snocomm
#
#  Created by Andres Barbudo on 12/21/23.
#  Copyright © 2023 Snocomm. All rights reserved.



# Script para utilizar ldid en el contexto de iOS

echo "Bienvenido al script que utiliza ldid"

# Comprueba si se proporciona el nombre del ejecutable
if [ -z "$1" ]; then
echo "Uso: $0 <nombre_del_ejecutable>"
exit 1
fi

# Nombre del ejecutable
ejecutable="$1"

# Llama a ldid para firmar el ejecutable (en un contexto de iOS)
echo "Firmando el ejecutable con ldid..."
ldid -S "$ejecutable"

# Muestra información sobre el ejecutable firmado
echo "Información sobre el ejecutable firmado:"
otool -l "$ejecutable" | grep -A 3 "LC_CODE_SIGNATURE"

echo "Fin del script."
