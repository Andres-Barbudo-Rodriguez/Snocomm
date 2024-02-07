#!/usr/bin/env python

import os
import socket
import threading
import socketserver

SERVER_HOST = 'localhost'
SERVER_PORT = 0						# this value of 0 tells the kernel to pickup a port dynamically
BUF_SIZE = 1024
ECHO_MSG = 'Echo Server activo?'

class ForkedClient():
	""" cliente para hacer test del servidor """
	def __init__(self, ip, port):
		# crear el socket
		self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

		# conectar al servidor
		self.sock.connect((ip,port))

	def run(self):
		""" cliente interactuando con el servidor """
		# enviar datos al servidor
		current_process_id = os.getpid()
		print('PID %s Enviando mensaje echo al servidor: "%s"' %(current_process_id, ECHO_MSG))
		sent_data_length = self.sock.send(bytes(ECHO_MSG, 'utf-8'))

		print("Enviados: %d caractéres..." %sent_data_length)

		# mostrar la respuesta del servidor
		response = self.sock.recv(BUF_SIZE)
		print("PID %s recibido: %s" % (current_process_id, response[5:]))

	def shutdown(self):
		""" limpiar el socket de cliente """
		self.sock.close()

class ForkingServerRequestHandler(socketserver.BaseRequestHandler):
	def handle(self):
		# devolver el mensaje echo al cliente

		# received = str(sock.recv(1024, "utf-8")
		data = str(self.request.recv(BUF_SIZE), 'utf-8')

		current_process_id = os.getpid()
		response = '%s: %s' % (current_process_id, data)
		print("El servidor está enviando la respuesta [current_process_id: data] = [%s]" %response)
		self.request.send(bytes(response, 'utf-8'))
		return

class forkingServer(socketserver.ForkingMixIn, socketserver.TCPServer,):
	""" no se adiciona nada aquí, el genesis hereditario obtuvo todo """
	pass


def main():
	# Inicializar el Servidor
	server = forkingServer((SERVER_HOST, SERVER_PORT), ForkingServerRequestHandler)
	ip, port = server.server_address					# obtiene el numero de puerto
	server_thread = threading.Thread(target=server.serve_forever)
	server_thread.setDaemon(True)						# esta linea anula el proceso de finalizar el servicio si el programa se cierra
	server_thread.start()
	print("Bucle del Servidor corriend en el PID: %s" %os.getpid())

	# inicializar el cliente

	""" Snocomm utiliza 3 clientes pero usted puede utilizar cientos de clientes """

	client1 = ForkedClient(ip, port)
	client1.run()

	print("Primer cliente ejecutandose")

	client2 = ForkedClient(ip, port)
	client2.run()

	print("segundo cliente ejecutandose")

	client3 = ForkedClient(ip, port)
	client3.run()

	print("tercer cliente ejecutandose")

	# limpiar

	server.shutdown
	client1.shutdown()
	client2.shutdown()
	client3.shutdown()

	server.socket.close()


if __name__ == '__main__':
	main()

















