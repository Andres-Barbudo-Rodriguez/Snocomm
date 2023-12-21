

#  15.zsh
#  Snocomm
#
#  Created by Andres Barbudo on 12/21/23.
#  Copyright © 2023 Snocomm. All rights reserved.



# Script para utilizar Cycript para explorar el entorno runtime de una aplicación

echo "Bienvenido al script de exploración con Cycript"

# Comprueba si se proporciona el proceso o la aplicación como argumento
if [ -z "$1" ]; then
echo "Uso: $0 <nombre_del_proceso_o_aplicacion>"
exit 1
fi

# Nombre del proceso o aplicación
proceso="$1"

# Llama a Cycript para explorar el entorno runtime
echo "Explorando el entorno runtime con Cycript..."
cycript -p "$proceso"

echo "Fin del script."
