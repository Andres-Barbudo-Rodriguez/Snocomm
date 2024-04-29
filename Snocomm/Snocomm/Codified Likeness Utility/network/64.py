#!/usr/bin/env python

import socket
import netifaces as ni
import netaddr as na

def extract_ipv6_info():
    print("Soporte para IPv6 construido en Python: %s" %socket.has_ipv6)
    for interface in ni.interfaces():
        all_addresses = ni.ifaddresses(interface)
        print("Interface: %s" %interface)
        for family,addrs in all_addresses.items():
            fam_name = ni.address_families[family]

            for addr in addrs:
                if fam_name == 'AF_INET6':
                    addr = addr['addr']
                    has_eth_string = addr.split("%eth")
                    if has_eth_string:
                        addr = addr.split("%eth")[0]
                    try:
                        print("         Direccion IP: %s" %na.IPNetwork(addr))
                        print("         Version de IP: %s" %na.IPNetwork(addr).version)
                        print("         Tamaño del Prefijo de IP: %s" %na.IPNetwork(addr).prefixlen)
                        print("         Red: %s" %na.IPNetwork(addr).network)
                        print("         Difusion: %s" %na.IPNetwork(addr).broadcast)
                    except Exception as e:
                        print("Omitido, No tiene interface IPv6")

if __name__ == '__main__':
    extract_ipv6_info()