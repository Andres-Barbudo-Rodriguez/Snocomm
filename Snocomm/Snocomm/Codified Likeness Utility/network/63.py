#!/usr/bin/env python

import socket
import argparse
import netifaces as ni

def inspect_ipv6_support():
    print("soporte para IPv6 esta construido en Python: %s", socket.has_ipv6)
    ipv6_addr = {}
    for interface in ni.interfaces():
        all_addresses = ni.ifaddresses(interface)
        print("Interface %s: " %interface)

        for family,addrs in all_addresses.items():
            fam_name = ni.address_families[family]
            print('     Address Family: %s' % fam_name)
            for addr in addrs:
                if fam_name == 'AF_INET6':
                    ipv6_addr[interface] = addr['addr']
                print('     Direccion : %s' % addr['addr'])
                nmask = addr.get('netmask', None)
                if nmask:
                    print('     Mascara de Subred  : %s' % nmask)
                    bcast = addr.get('broadcast', None)
                    if bcast:
                        print('     Difusion  : %s' %bcast)
    if ipv6_addr:
        print("Se encontraron las siguientes direcciones IPv6: %s" %ipv6_addr)
    else:
        print("No se encontro ninguna interface con capacidad IPv6")

if __name__ == '__main__':
    inspect_ipv6_support
