#!/usr/bin/env python

import argparse
import socket
import sys

HOST = 'localhost'
BUFSIZE = 1024

def ipv6_echo_client(port, host=HOST):
    for res in socket.getaddrinfo(host, port, socket.AF_UNSPEC, socket.SOCK_STREAM):
        af, socktype, proto, canonname, sa = res
        try:
            sock = socket.socket(af, socktype, proto)
        except socket.error as err:
            print("Error:%s" %err)
        try:
            sock.connect(sa)
        except socket.error as msg:
            sock.close()
            continue
    if sock is None:
        print("Ocurrió un fallo al intentar abrir el socket")
        sys.exit(1)
        msg = "Este es el cliente IPv6"
        print("Datos enviados al servidor: %s" %msg)
        sock.send(bytes(msg.encode('utf-8')))
        while True:
            data = sock.recv(BUFSIZE)
            print("Recibido desde el servidor", repr(data))
            if not data:
                break
        sock.close()

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Cliente de Socket IPv6')
    parser.add_argument('--port', action="store", dest="port", type=int, required=True)
    given_args = parser.parse_args()
    port = given_args.port
    ipv6_echo_client(port)