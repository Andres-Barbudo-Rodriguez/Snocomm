import argparse
import sys

from http.server import BaseHTTPRequestHandler, HTTPServer
# python 2.7.x
# from baseHTTPServer import BaseHTTPRequestHandler, HTTPServer

DEFAULT_HOST = '127.0.0.1'
DEFAULT_PORT = 8800

class RequestHandler(BaseHTTPRequestHandler):
	def do_GET(self):
		self.send_response(200)
		self.send_header('content-type', 'text/html')
		self.send_headers()
		# browser
		self.wfile.write("Here is the Server!")
		return

class CustomHTTPServer(HTTPServer):
	def __init__(self, host, port):
		server_address = (host, port)
		HTTPServer.__init__(self, server_address, RequestHandler)

def run_server(port):
	try:
		server = CustomHTTPServer(DEFAULT_HOST, port)
		print("Servidor iniciado en el puerto: %s" % port)
		server.serve_forever()
	except Exception as err:
		print("Error:%s" %err)
	except KeyboardInterrupt:
		print("Servidor interrumpido, el sistema se está apagando...")
		server.socket.close()


if __name__ == "__main__":
	parser = argparse.ArgumentParser(description="Servidor de HTTP")
	parser.add_argument('--port', action="store", dest="port", type=int, default=DEFAULT_PORT)
	given_args = parser.parse_args()
	port = given_args.port
	run_server(port)











