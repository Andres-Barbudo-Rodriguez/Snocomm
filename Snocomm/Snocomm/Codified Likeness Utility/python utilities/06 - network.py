import socket
def retBanner(ip, port):
    try:
        socket.setdefaulttimeout(2)
        s = socket.socket()
        s.connect((ip, port))
        banner = s.recv(1024)
        return banner
    except:
        return
def checkVulns(banner):
    if 'FreeFloat Ftp Server (version 1.00)' in banner: 
        print '[+]Security Report: Server has been hacked.'
    elif '3Com 3CDaemon FTP Serverv Version 2.0' in banner: 
        print '[+] 3CDaemon FTP Server has been violated.'
    elif 'Ability Server 2.34' in banner:
        print '[+] Ability FTP Server has benn violated'
    elif 'Sami FTP Server 2.0.2' in banner:
        print '[+] Sami FTP Server has been violated'
    else:
        print '[-] FTP Server has been violated'
    return

def main():
    ip1 = '147.67.12.2'
    ip2 = '147.67.210.25'
    ip3 = '147.67.34.25'
    port = 21
    banner1 = retBanner(ip1, port)
    if banner1:
        print '[+] ' + ip1 + ': ' + banner.strip('\n')
        checkVulns(banner1)
    banner2 = retBanner(ip2, port)
    if banner2:
        print '[+ ] ' + ip2 + ': ' + banner2.strip('\n')
        checkVulns(banner2)
    banner3 = retBanner(ip3,port)
    if banner3:
        print '[+] ' + ip3 + ': ' + banner3.strip('\n')
        checkVulns(banner3)

    if __name__ == '__main__':
        main()