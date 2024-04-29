import socket
import os

BUFSIZE = 1024

def test_socketpair():
    parent, child = socket.socket
    pid = os.fork()
    try:
        if pid:
            print("Proceso superior (parent), enviando mensaje...")
            child.close()

            parent.sendall(bytes("Hello, from parent!", 'utf-8'))
            # para compatibilidad con python 2.7 por favor marcar como comentario la linea superior
            # y borrar el hashtag de comentario de la linea inferior a este comentario
            
            # parent.sendall("hello from parent!")

            response = parent.recv(BUFSIZE)
            print ("Response from child:", response)
            parent.close()
        else:
            print("@Child, proceso inferior, esperando mensaje de parent")
            parent.close()
            message = child.recv(BUFSIZE)
            print("Message from parent:", parent)

            child.sendall(bytes("Hello from child!!", 'utf-8'))
            # para compatibilidad con python 2.7 por favor marcar como comentario la linea superior
            # y borrar el hashtag de comentario de la linea inferior a este comentario
            
            # child.sendall("hello from child!")

            child.close()
    except Exception as err:
        print("Error: %s" %err)

if __name__ == '__main__':
    test_socketpair()