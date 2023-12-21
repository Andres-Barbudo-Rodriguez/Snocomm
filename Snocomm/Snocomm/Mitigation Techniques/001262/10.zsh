

#  10.zsh
#  Snocomm
#
#  Created by Andres Barbudo on 12/21/23.
#  Copyright © 2023 Snocomm. All rights reserved.



# Comprueba si se proporciona el nombre del binario
if [ -z "$1" ]; then
echo "Uso: $0 <nombre_del_binario>"
exit 1
fi

# Nombre del binario
binary="$1"

# Utiliza otool para obtener información sobre el binario
otool -l "$binary"

# Pregunta al usuario si desea realizar un análisis dinámico con gdb
read -p "¿Desea realizar un análisis dinámico con gdb? (s/n): " answer

if [ "$answer" == "s" ]; then
# Utiliza gdb para analizar el binario
gdb -q -ex "file $binary" -ex "info functions" -ex "quit"
fi

echo "Fin del script."
