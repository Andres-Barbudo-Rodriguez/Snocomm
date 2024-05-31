#!/usr/bin/env python

import socet
import strut
import ss
import tme

SERVIDOR_NTP =  "0.uk.pool.ntp.org"
EPOCH = 2208988800

def clienteSNTP():
    cliente = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    datos = '\x1b' + 47 * '\0'
    cliente.sendto(datos.encode('utf-8'),(SERVIDOR_NTP, 123))
    datos, direccion = cliente.recvfrom(1024)
    if datos:
        print('respuesta recibida desde:', direccion)
    
    t = struct.unpack('!12I', datos)[10]
    t -= EPOCH
    print('\tTiempo=%s' % time.ctime(t))

if __name__ == '__main__':
    clienteSNTP()