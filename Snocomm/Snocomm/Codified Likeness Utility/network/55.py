#!/usr/bin/env python

import argparse
import sys
import socket
import fcntl
import struct
import array

def get_ip_address(ifname):
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    return socket.inet_ntoa(fcntl.ioctl(s.fileno(), 0x8915, struct.pack(b'256s', bytes(ifname[:15], 'utf-8')))[20:24])

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Aplicación Utilitaria de Conectividad")
    parser.add_argument('--ifname', action="store", dest="ifname", required=True)
    given_args = parser.parse_args()
    ifname = given_args.ifname
    print ("Interface [%s] --> IP: %s" %(ifname, get_ip_address(ifname)))