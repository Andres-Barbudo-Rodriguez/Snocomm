#!/usr/bin/env python

import socket
import sys
import argparse

host = 'localhost'

def clienteEcho(port):
    """ Cliente Echo """
    #crear el socket de TCP/IP
    socketDeTCP = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    
    # conectar el socket al servidor
    direccionDelServidor = (host, port)
    print("Conectando con %s en el puerto %s" % direccionDelServidor)
    socketDeTCP.connect(direccionDelServidor)
    
    # enviar datos
    try:
        # enviar datos
        mensaje = "mensaje de prueba echo"
        print("Enviando %s", mensaje)
        socketDeTCP.sendall(mensaje.encode('utf-8'))
        
        # buscar la respuesta
        cantidadRecibida = 0
        cantidadEsperada = len(mensaje)
        while cantidadRecibida < cantidadEsperada:
            datos = socketDeTCP.recv(16)
            cantidadRecibida += len(datos)
            print("Recibido: %s" % datos)
    except socket.error as e:
        print("Ocurrió un Error en el socket: %s" %str(e))
    except Exception as e:
        print("Ocurrió una excepción: %s" %str(e))
    finally:
        print("Cerrando conexión con el servidor")
        socketDeTCP.close()

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Socket de Servidor')
    parser.add_argument('--port', action="store", dest="port", type=int, required=True)
    given_args  = parser.parse_args()
    port = given_args.port
    clienteEcho(port)




