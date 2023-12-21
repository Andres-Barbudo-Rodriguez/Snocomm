

#  11.zsh
#  Snocomm
#
#  Created by Andres Barbudo on 12/21/23.
#  Copyright © 2023 Snocomm. All rights reserved.



# Script para monitorear una aplicación con gprof

echo "Bienvenido al script de monitoreo con gprof"

# Comprueba si se proporciona el nombre del ejecutable
if [ -z "$1" ]; then
echo "Uso: $0 <nombre_del_ejecutable>"
exit 1
fi

# Nombre del ejecutable
ejecutable="$1"

# Compila la aplicación con la opción -pg para habilitar el profiling
echo "Compilando la aplicación con opciones de profiling..."
gcc -pg -o "$ejecutable" "$ejecutable.c"

# Ejecuta la aplicación
echo "Ejecutando la aplicación..."
./"$ejecutable"

# Genera el archivo de perfil con gprof
echo "Generando el archivo de perfil con gprof..."
gprof ./"$ejecutable" > gprof_output.txt

# Muestra el informe generado por gprof
echo "Informe de gprof:"
cat gprof_output.txt

# Limpia los archivos temporales
rm -f gmon.out gprof_output.txt

echo "Fin del script."
