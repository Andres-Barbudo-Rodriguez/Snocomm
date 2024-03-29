import socket

def test_socket_modes():
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.setblocking(1)            # valor de 1 en modo bloqueado y valor 0 en modo desbloqueo
    s.settimeout(0.5)
    s.bind(("127.0.0.1",0))
    socket_address = s.getsockname()
    print("Servidor inicializado en el socket: %s" %str(socket_address))

    while(1):
        s.listen(1)

if __name__ == '__main__':
    test_socket_modes()