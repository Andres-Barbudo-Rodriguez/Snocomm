#!/bin/sh

#  04 - Test en el Cliente.sh
#  Snocomm
#
#  Created by Andres Barbudo Rodriguez on 11/28/23.
#  Copyright © 2023 Snocomm. All rights reserved.

# funcion de validación de entrada
validate_ip() {
    local ip="$1"
    # validación simple de expresión regular para la validación IP
    if [[ ! ip =~ ^[0-9] +\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "Error: formato de dirección IP no válido"
        exit 1
    fi
}


# Verificar que el comando openssl está disponible
if ! command -v openssl &> /dev/null; then
    echo "Error: OpenSSL no está instalado. Por favor instale macports desde macports.org y corra el siguiente comando en su terminal en modo root, `port search openssl11`, y si está disponible por favor instálelo"
    exit 1
fi


# Solicitar al usuario el ingreso de la dirección IP del servidor de forma asegurada

read -rsp "Ingrese la dirección IP del servidor: " server_ip
echo

# validar la ip ingresada
validate_ip "$server_ip"

# correr s_client con la ip ingresada
openssl s_client -connect "$(server_ip):4433"
