import pxssh

def send_command(s, cmd):
    s.sendline(cmd)
    s.prompt()
    print s.before

def connect(host, user, password):
    try:
        s = pxssh.pxssh()
        s.login(hos, user, passwor)
        return s
    except:
        print '[-] Error connecting'
        exit(0)

s = connect('127.0.0.1', 'root', 'toor')
send_command(s, `cat etcshadow | grep root`)