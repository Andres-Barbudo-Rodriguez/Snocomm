#!/usr/bin/env python

import os
import argparse
import socket
import struct
import select
import time

ICMP_ECHO_REQUEST = 8 # específico a cada plataforma
DEFAULT_TIMEOUT = 2
DEFAULT_COUNT = 4

class Pinger(object):
    """obtiene ping de un host"""
    def __init__(self, target_host, count=DEFAULT_COUNT, timeout=DEFAULT_TIMEOUT):
        self.target_host = target_host
        self.count = count
        self.timeout = timeout
    
    def do_checksum(self, source_string):
        """ verificacion de integridad de capa tres"""
        sum = 0
        max_count = (len(source_string)/2)*2
        count = 0
        while count < max_count:
            ###########################################################################
            # nota sobre compatibilidad con python2:
            # 1. ejecutar la siguiente instrucción por fuera de la linea de comentario
            ###########################################################################
            """
            val  = ord(source_string[count + 1])*256 + ord(source_string[count])
            """
            #########################################################
            # 2. agregar prompt de comentario a la siguiente linea
            #########################################################
            val = source_string[count + 1]*256 + source_string[count]
            ###########################################################
            # 3. no se utiliza ord en la versionn de Python3 porque
            #    indexar un objeto en bytes devuelve un entero
            #    en cuyo caso ord es redundante
            ###########################################################

            sum += val                       
            sum &= 0xffffffff
            count += 2

        if max_count < len(source_string):
            sum += ord(source_string[len(source_string) - 1])
            sum &= 0xffffffff
        sum = (sum >> 16) + (sum & 0xffff)

        sum += (sum >> 16)
        answer = ~sum
        answer &= 0xffff
        answer = answer >> 8 | (answer << 8 & 0xff00)
        return answer
    
    def receive_pong(self, sock, ID, timeout):
        """Recibir el ping desde el soket"""
        time_remaining = timeout
        while True:
            start_time = time.time()
            readable = select.select([sock], [], [], time_remaining)
            time_spent = (time.time() - start_time)

            if readable[0] == []: # Tiempo Agotado
                return
            
            time_received = time.time()
            recv_packet, addr = sock.recvfrom(1024)
            imcp_header = recv_packet[20:28]
            type, code, checksum, packet_ID, sequence = struct.unpack("bbHHh", imcp_header)

            if packet_ID == ID:
                bytes_In_double = struct.calcsize("d")
                time_sent = struct.unpack("d", recv_packet[28:28 + bytes_In_double]) [0]
                return time_received - time_sent
            
            time_remaining = time_remaining - time_spent
            if time_remaining <= 0:
                return
    
    def send_ping(self, sock, ID):
        """ enviar el ping al host objetivo"""
        target_addr = socket.gethostbyname(self.target_host)
        my_checksum = 0
        header = struct.pack("bbHHh", ICMP_ECHO_REQUEST, 0, my_checksum, ID, 1)
        bytes_In_double = struct.calcsize("d")
        data = (192 - bytes_In_double) * "Q"
        data = struct.pack("d", time.time()) + bytes(data.encode('utf-8'))
        my_checksum = self.do_checksum(header + data)
        header = struct.pack("bbHHh", ICMP_ECHO_REQUEST, 0, socket.htons(my_checksum), ID, 1)
        packet = header + data
        sock.sendto(packet, (target_addr, 1))

    def ping_once(self):
        """obtiene el retrazo (contado en segundos) o cero cuando se agota el tiempo"""
        icmp = socket.getprotobyname("icmp")
        try:
            sock = socket.socket(socket.AF_INET, socket.SOCK_RAW, icmp)
        except socket.errno as e:
            if e.errno == 1:
                # el Usuario no es administrador Root, operación rechazada
                e.msg += "el envio de muestras ICMP solo están autorizadas a procesos (no usuarios) del modo root"
                raise socket.error(e.msg)
        except Exception as e:
            print ("Ocurrió una excepción: %s" %(e))
        my_ID = os.getpid() & 0xFFFF
        self.send_ping(sock, my_ID)
        delay = self.receive_pong(sock, my_ID, self.timeout)
        sock.close()
        return delay

    def ping(self):
        """Ejecutar el proceso ping"""
        for i in range(self.count):
            print("enviando ping hacia %s..." % self.target_host,)
            try:
                delay = self.ping_once()
            except socket.gaierror as e:
                print("el ping falló. (error de socket: '%s')" % e[1])
                break
            if delay == None:
                print("el ping falló. (el tiempo se agotó antes de ocurrir el delay %s sec.)" % self.timeout)
            
            else:
                delay = delay * 1000
                print("obtener el pong en %0.4fms" % delay)
            
if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Ping en Python")
    parser.add_argument('--target-host', action="store", dest="target_host", required=True)
    given_args = parser.parse_args()
    target_host = given_args.target_host
    pinger = Pinger(target_host=target_host)
    pinger.ping()


