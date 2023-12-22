

#  14.zsh
#  Snocomm
#
#  Created by Andres Barbudo on 12/21/23.
#  Copyright © 2023 Snocomm. All rights reserved.



# Script para monitorear una aplicación con ltrace

echo "Bienvenido al script de monitoreo con ltrace"

# Comprueba si se proporciona el nombre del ejecutable
if [ -z "$1" ]; then
echo "Uso: $0 <nombre_del_ejecutable>"
exit 1
fi

# Nombre del ejecutable
ejecutable="$1"

# Llama a ltrace para monitorear el ejecutable
echo "Monitoreando el ejecutable con ltrace..."
ltrace ./"$ejecutable" 2> ltrace_output.txt

# Muestra el resultado de ltrace
echo "Resultados de ltrace:"
cat ltrace_output.txt

echo "Fin del script."
