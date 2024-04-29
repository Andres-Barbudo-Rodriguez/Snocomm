#!/usr/bin/env python

import socket
import sys

SERVER_PATH = "/tmp/python_unix_socket_server"

def run_unix_domain_socket_client():
    sock = socket.socket(socket.AF_UNIX, socket.SOCK_DGRAM)
    # conectar con la ruta en la cual el servidor tiene escucha activa
    server_address = SERVER_PATH
    print("connecting to %" % server_address)
    try:
        sock.connect(server_address)
    except socket.error as msg:
        print(msg)
        sys.exit(1)
    try:
        message = "Este es el mensaje original, Este mensaje será replicado"
        print("enviando[%s]" %message)

        sock.sendall(bytes(message, 'utf-8'))
        # para compatibilidad con python 2.7 por favor marcar como comentario la linea superior
        # y borrar el hashtag de comentario de la linea inferior a este comentario
            
        # sock.sendall(message)

        amount_received = 0
        amount_expected = len(message)
        while amount_received < amount_expected:
            data = sock.recv(16)
            amount_received += len(data)
            print ("Recibidos [%s]" % data)
    finally:
        print("Cerrando el cliente")
        sock.close()

if __name__ == '__main__':
    run_unix_domain_socket_client()