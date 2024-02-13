# ejecutar de la siguiente forma:
# python3 30.py --name=server --port=8800
# ejecutarlo en 3 terminales diferentes y observar la interacción y respuesta
# en cada terminal


#!/usr/bin/env python

import select
import socket
import sys
import signal
import pickle
import struct
import argparse

SERVER_HOST = 'localhost'
CHAT_SERVER_NAME = 'server'

# funciones utilitarias

def send(channel, *args):
    buffer = pickle.dumps(args)
    value = socket.htonl(len(buffer))
    size = struct.pack("L", value)
    channel.send(size)
    channel.send(buffer)

def receive(channel):
    size = struct.calcsize("L")
    size = channel.recv(size)
    try:
        size = socket.ntohl(struct.unpack("L", size)[0])
    except struct.error as e:
        return ''
    buf = ""
    while len(buf) < size:
        buf = channel.recv(size - len(buf))
        return pickle.loads(buf)[0]
    

    class ChatServer(object):
        """servidor de red de gran escala utilizando select"""
        def __init__(self, port, backlog=5):
            self.clients = 0
            self.clientmap = {}
            self.outputs = []  # listar los sockets de salida
            self.server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            self.server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
            self.server.bind((SERVER_HOST, port))
            print('Servidor escuchando en el puerto: %s ...' %port)
            self.server.listen(backlog)

            # obtener la salida abrupta por interrupcion del teclado
            signal.signal(signal.SIGINT, self.sighandler)
        
        def sighandler(self, signum, frame):
            """limpiar las salidas del cliente"""
            # Cerrar el servidor
            print("Cerrando el servidor...")
            # cerrar los sockets de cliente existentes
            for output in self.outputs:
                output.close()
                self.server.close()
        
        def get_client_name(self, client):
            """devolver el nombre del cliente"""
            info = self.clientmap[client]
            host, name = info[0][0], info[1]
            return '@'.join((name, host))
        
        def run(self):
            inputs = [self.server, sys.stdin]
            self.outputs = []
            running = True
            while running:
                try:
                    readable, writeable, exceptional = select.select(inputs, self.outputs, [])
                except select.error as e:
                    break
                for sock in readable:
                    if sock == self.server:
                        # gestionar el socket de servidor
                        client, address = self.server.accept()
                        print("Sevidor de Chat: obtuve conexión %d desde %s" %(client.fileno(), address))
                        # leer el nombre de inicio de sesión
                        cname = receive(client).split('NAME: ')[1]
                        # computar el nombre de cliente y enviarlo de regreso
                        self.clients += 1
                        send(client, 'CLIENT: ' +str(address[0]))
                        inputs.append(client)
                        self.clientmap[client] = address (address, cname)
                        # enviar la información de ingreso a otros clientes
                        msg = "\n(Conectado: Nuevo cliente (%d) desde %s)" %(self.clients, self.get_client_name(client))
                        for output in self.outputs:
                            send(output, msg)
                            self.outputs.append(client)
                        
                    elif sock == sys.stdin:
                        # gestionar la entrada estandar
                        try:
                            data = receive(sock)
                            if data:
                                # enviar mensaje como nuevo cliente
                                msg = '\n#[' + self.get_client_name(sock) + ']>>' + data
                                # enviar datos a todos pero no a la maquina local
                                for output in self.outputs:
                                    if output != sock:
                                        send(output, msg)
                            else:
                                print("Servidor de Chat: %d recibió señal de detención y ha terminado el proceso" % sock.fileno())
                                self.clients -= 1
                                sock.close()
                                inputs.remove(sock)
                                self.outputs.remove(sock)

                                # enviando la información de finalizacion del cliente a los demás
                                msg = "\n(Terminal de control finalizada: Cliente desde %s)" %self.get_client_name(sock)
                                for output in self.outputs:
                                    send(output, msg)
                        except socket.error as e:
                            # eliminar
                            inputs.remove(sock)
                            self.outputs.remove(sock)
            self.server.close()                        



class ChatClient(object):
    """cliente de red via linea de comandos utilizando select"""

    def __init__(self, name, port, host=SERVER_HOST):
        self.name = name
        self.connected = False
        self.host = host
        self.port = port
        
        # prompt inicial
        self.prompt='['+ '@'.join((name, socket.gethostname().split('.')[0])) +']>'

        # conectar con el servidor en el puerto
        try:
            self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            self.sock.connect((host, self.port))
            print("Conexión establecida en el puerto % del servidor de chat" % self.port)
            self.connected = True
            
            # enviar el nombre de la maquina local
            send(self.sock,'NAME: ' + self.name)
            data = receive(self.sock)
            
            # contiene la direccion del cliente
            addr = data.split('CLIENT: ') [1]
            self.prompt = '[' + '@'.join((self.name, addr)) + ']>'
        except socket.error as e:
            print ("Fallo al conectar con el servidor en el puerto %d" % self.port)
            sys.exit(1)
    
    def run(self):
        """bucle principal del cliente"""
        while self.connected:
            try:
                sys.stdout.write(self.prompt)
                sys.stdout.flush()
                
                # esperar la entrada de stdin() y socket()
                readable, writeable, exceptional = select.select([0, self.sock], [], [])
                for sock in readable:
                    if sock == 0:
                        data = sys.stdin.readline().strip()
                        if data: send(self.sock, data)
                    elif sock == self.sock:
                        data = receive(self.sock)
                        if not data:
                            print('Apagando al cliente.')
                            self.connected = False
                            break
                        else:
                            sys.stdout.write(data + '\n')
                            sys.stdout.flush()
            except KeyboardInterrupt:
                print("El cliente fue interrumpido." "")
                self.sock.close()
                break

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Socket de Servidor con Select')
    parser.add_argument('--name', action="store", dest="name", required=True)
    parser.add_argument('--port', action="store", dest="port", type=int, required=True)

    given_args = parser.parse_args()
    port = given_args.port
    name = given_args.name

    if name == CHAT_SERVER_NAME:
        server = ChatServer(port)
        server.run()
    else:
        client = ChatClient(name=name, port=port)
        client.run()