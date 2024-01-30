#include <stdio.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <string.h>
#include <arpa/inet.h>

int main() {
    int socketDelCliente;
    char str[255];
    struct sockaddr_in direccionDelCliente;
    socklen_t tamañoDeLaDireccion;
    
    socketDelCliente                            = socket(AF_INET, SOCK_STREAM, 0);
    direccionDelCliente.sin_family              = AF_INET;
    direccionDelCliente.sin_port                = htons(2000);
    direccionDelCliente.sin_addr.s_addr         = inet_addr("127.0.0.1");
    
    memset(direccionDelCliente.sin_zero, '\0', sizeof direccionDelCliente.sin_zero);
    tamañoDeLaDireccion = sizeof direccionDelCliente;
    connect(socketDelCliente, (struct sockaddr *) &direccionDelCliente, tamañoDeLaDireccion);
    recv(socketDelCliente, str, 255, 0);
    printf("datos recibidos del servidor: %s", str);
    return 0;
}
