#!/usr/bin/env python

import argparse

import urllib.request
# para compatibilidad con python 2.7.x poner como comentario la linea superior a esta linea
# y borrar el hastag de comentario de la siguiente linea

# import urllib2

REMOTE_SERVER_HOST = 'https://www.github.com'

class HTTPClient:
	def __init__(self, host):
		self.host = host

	def fetch(self):
		response = urllib.request.urlopen(self.host)
		# para compatibilidad con python 2.7.x poner como comentario la linea superior a esta linea
		# y borrar el hastag de comentario de la siguiente linea
		
		# response = urllib2.urlopen(self.host)

		data = response.read()
		text = data.decode('utf-8')
		return text

if __name__ == '__main__':
	parser = argparse.ArgumentParser(description="Cliente HTTP")
	parser.add_argument('--host', action="store", dest="host", default=REMOTE_SERVER_HOST)

	given_args = parser.parse_args()
	host = given_args.host
	client = HTTPClient(host)
	print(client.fetch())