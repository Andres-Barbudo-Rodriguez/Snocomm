#!/usr/bin/env python

import socket
import sys

def reutilizarLaDireccionDeSocket():
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    # obtener el estado anterior de la opción SO_REUSEADDR

    estadoAnterior = sock.getsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR)
    print("El estado anterior del socket es: %s" %estadoAnterior)

    # habilitar la opción SO_REUSEADDR
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

    estadoActual = sock.getsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR)
    print("Estado actual del socket: %s" %estadoActual)

    puertoLocal = 8282
    srv = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    srv.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    srv.bind(('', puertoLocal))
    srv.listen(1)
    print("Escucha activa en el puerto: %s " %puertoLocal)
    while True:
        try:
            conexion, direccion = srv.accept()
            print("Conectado por %s:%s" % (direccion[0], direccion[1]))
        except KeyboardInterrupt:
            break
        except socket.error as msg:
            print('%s' % (msg,))

if __name__ == '__main__':
    reutilizarLaDireccionDeSocket()