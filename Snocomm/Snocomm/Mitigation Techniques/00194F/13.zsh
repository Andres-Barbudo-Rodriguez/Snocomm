

#  13.zsh
#  Snocomm
#
#  Created by Andres Barbudo on 12/21/23.
#  Copyright © 2023 Snocomm. All rights reserved.



# Script para monitorear una aplicación con strace

echo "Bienvenido al script de monitoreo con strace"

# Comprueba si se proporciona el nombre del ejecutable
if [ -z "$1" ]; then
echo "Uso: $0 <nombre_del_ejecutable>"
exit 1
fi

# Nombre del ejecutable
ejecutable="$1"

# Llama a strace para monitorear el ejecutable
echo "Monitoreando el ejecutable con strace..."
strace ./"$ejecutable" 2> strace_output.txt

# Muestra el resultado de strace
echo "Resultados de strace:"
cat strace_output.txt

echo "Fin del script."
