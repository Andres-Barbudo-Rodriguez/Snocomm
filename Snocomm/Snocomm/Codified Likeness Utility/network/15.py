#!/usr/bin/env python


impot socket
impot sys


host = 'localhost'
data_payload = 2048

def servidorEcho(port):
    """ Servidor Echo """
    # crear un socket UDP
    socketDeUDP = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    
    # conectar el socket al puerto
    direccionDelServidor = (host, port)
    print("Inicializando el servidor echo en %s puerto %s" % direccionDelServidor)
    socketDeUDP.bind(direccionDelServidor)
    
    while True:
        print("Esperando a recibir el mensaje desde el cliente")
        datos, direccion = socketDeUDP.recvfrom(data_payload)
        print("recibidos %s bytes desde %s" % (len(datos), direccion))
        print("Datos: %s" %datos)
        
        if datos:
            enviados = socketDeUDP.sendto(datos, direccion)
            print("enviados %s bytes de vuelta a %s" % (enviados, direccion))
            

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Socket de Servidor')
    parser.add_argument('--port', action="store", dest="port", type=int, required=True)
    given_args = parser.parse_args()
    port = given_args.port
    servidorEcho(port)










