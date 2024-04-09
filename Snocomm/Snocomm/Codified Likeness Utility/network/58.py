import argparse
import time
import sched
from scapy.all import sr, srp, IP, UDP, ICMP, TCP, ARP, Ether

RUN_FREQUENCY = 10

scheduler = sched.scheduler(time.time, time.sleep)

def detect_inactive_hosts(scan_hosts):
    global scheduler
    scheduler.enter(RUN_FREQUENCY, 1, detect_inactive_hosts, (scan_hosts, ))
    inactive_hosts = []
    try:
        ans, unans = sr(IP(dst=scan_hosts)/ICMP(), retry=0, timeout=1)
        ans.summary(lambda r : r.sprintf("%IP.src% se encuentra activa"))
        for inactive in unans:
            print("%s esta inactiva" %inactive.dst)
        print("Un total de %s hosts se encuentran inactivos" %(len(inactive_hosts)))
    except KeyboardInterrupt:
        exit(0)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Aplicacion Utilitaria de Conectividad")
    parser.add_argument('--scan-hosts', action="store", dest="scan_hosts", required=True)
    given_args = parser.parse_args()
    scan_hosts = given_args.scan_hosts
    scheduler.enter(1, 1, detect_inactive_hosts, (scan_hosts, ))
    scheduler.run