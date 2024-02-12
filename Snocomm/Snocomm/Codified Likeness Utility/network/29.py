#!/usr/bin/env/ python

import os
import socket
import threading
import socketserver

SERVER_HOST = 'localhost'
SERVER_PORT = 0                     # instruye a la kernel seleccionar un puerto de forma dinamica
BUF_SIZE = 1024

def client(ip, port, message):
    """ cliente para probar el servidor en modo multi thread"""
    # conectar con el servidor
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect((ip, port))
    try:
        sock.sendall(bytes(message, 'utf-8'))
        response = sock.recv(BUF_SIZE)
        print("El cliente ha recibido la respuesta: %s" %response)
    finally:
        sock.close()

class ThreadedTCPRequestHandler(socketserver.BaseRequestHandler):
    """solicitud TCP en modo multi thread"""
    def handle(self):
        data = self.request.recv(1024)
        cur_thread = threading.current_thread()
        response = "%s: %s" % (cur_thread.name, data)
        self.request.sendall(bytes(response, 'utf-8'))

class ThreadedTCPServer(socketserver.ThreadingMixIn, socketserver.TCPServer):
    """no se añade nada más aqui el genesis hereda todo lo necesario"""
    pass

if __name__ == '__main__':
    # ejecutar el servidor
    server = ThreadedTCPServer((SERVER_HOST, SERVER_PORT), ThreadedTCPRequestHandler)
    ip, port = server.server_address              # obtiene la dirección ip

    # incia un thread con el servidor -- lo hace un thread por cada solicitud
    server_thread = threading.Thread(target=server.serve_forever)
    # cierra el thread de servidor cuando el thread principal se cierra
    server_thread.daemon = True
    server_thread.start()
    print("bucle de servidor ejectuandose en el thread: %s" %server_thread.name)
    # ejecutar los clientes
    client(ip, port, "Hello from client 1")
    client(ip, port, "hello from client 2")
    client(ip, port, "hello from client 3")
    # limpiado y finalizado del servidor
    server.shutdown()
