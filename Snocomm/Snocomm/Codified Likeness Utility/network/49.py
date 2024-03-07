#!/usr/bin/env python

import argparse
import socket
import errno
from time import time as now

DEFAULT_TIMEOUT = 120
DEFAULT_SERVER_HOST = 'localhost'
DEFAULT_SERVER_PORT = 80

class NetServiceChecker(object):
    """ Esperando a que el servicio de red se restaure """
    def __init__(self, host, port, timeout=DEFAULT_TIMEOUT):
        self.host = host
        self.port = port
        self.timeout = timeout
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    def end_wait(self):
        self.sock.close()
    
    def check(self):
        """ Revisando el estado de servicio """
        if self.timeout:
            end_timeout = now() + self.timeout
        while True:
            try:
                if self.timeout:
                    next_timeout = end_time - now()
                    if next_timeout < 0:
                        return False
                    else:
                        print ("estableciendo el contador de tiempo de espera del siguiente ciclo %ss" %round(next_timeout))
                        self.sock.settimeout(next_timeout)
                self.sock.connect((self.host, self.port))
            # gestión de errores
            except socket.timeout as err:
                if self.timeout:
                    return False
            except socket.error as err:
                print("Excepción: %s" %err)
            else: # si todo salió bien hasta acá
                self.end_wait()
                return True


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Esperando Servicio de Red')
    parser.add_argument('--host', action="store", dest="host", default=DEFAULT_SERVER_HOST)
    parser.add_argument('--port', action="store", dest="port", type=int, default=DEFAULT_SERVER_PORT)
    parser.add_argument('--timeout', action="store", dest="timeout", type=int, default=DEFAULT_TIMEOUT)
    given_args = parser.parse_args()
    host, port, timeout = given_args.host, given_args.port, given_args.timeout
    service_checker = NetServiceChecker(host, port, timeout=timeout)
    print ("Revisando el Servicio de Red %s:%s ..." %(host, port))
    if service_checker():
        print("Servicio Restablecido!")