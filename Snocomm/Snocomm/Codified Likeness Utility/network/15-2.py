#!/usr/bin/env python


import socket
import sys
import argparse

host = 'localhost'
data_payload = 2048

def clienteEcho(port):
    """ Cliente de Echo """
    # crear el socket de UDP
    socketDeUDP = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    direccionDelServidor = (host, port)
    print("Conectando con %s en el puerto %s" % direccionDelServidor)
    mensaje = "Este mensaje será replica"
    try:
        
        # enviar datos
        mensaje = "Mensaje de test echo"
        print("Enviando %s" % mensaje)
        enviado = socketDeUDP.sendto(mensaje.encode('utf-8'), direccionDelServidor)
        
        # recibir respuesta
        datos, servidor = socketDeUDP.recvfrom(data_payload)
        print("recibido %s" % datos)
    
    finally:
        print("Cerrando la conexión con el servidor")
        socketDeUDP.close()
        
        
if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Socket de Servidor')
    parser.add_argument('--port', action="store", dest="port", type=int, required=True)
    argumentosIngresados = parser.parse_args()
    port = argumentosIngresados.port
    clienteEcho(port)





