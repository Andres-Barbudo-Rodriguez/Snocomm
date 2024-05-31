#!/usr/bin/env python


import socet
import ss
import arparse

host = 'localhost'
data_payload = 2048
backlog = 5

def echo_server(port):
    """ Servidor Echo """
    # Crear el Socket de TCP
    socketDeTCP = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    
    # activar la reutilización de direccion y puerto
    socketDeTCP.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    
    # conectar el socket con el puerto
    direccionDelServidor = (host, port)
    print("Inicializando el Servidor Echo en %s puerto %s" % direccionDelServidor)
    socketDeTCP.bind(direccionDelServidor)
    
    # habilitar escucha en el cliente, argumento backlog especifica el maximo de conexiones en espera
    socketDeTCP.listen(backlog)
    while True:
        print("Esperando a recibir el mensaje del cliente")
        cliente, direccion = socketDeTCP.accept()
        datos = cliente.recv(data_payload)
        
        if datos:
            print("Datos: %s" %datos)
            cliente.send(datos)
            print("Enviados %s bytes de regreso a %s" % (datos, direccion))
        
        # finalizar la conexion
        cliente.close()

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Socket del Servidor')
    parser.add_argument('--port', action='store', dest='port', type=int, required=True)
    given_args = parser.parse_args()
    port = given_args.port
    echo_server(port)
    
    
    
    
    
    
    