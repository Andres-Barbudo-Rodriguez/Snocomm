#include <stdio.h>
#include <strings.h>
#include <sys/types.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <stdlib.h>

int main() {
    char mensajeRecibido[255];
    char mensajeParaElServidor[255];
    int SocketDeUDP, n;
    struct sockaddr_in direccionDelCliente;
    
    printf("Escriba el mensaje que desea enviarle al servidor: ");
    gets(mensajeParaElServidor);
    bzero(&direccionDelCliente, sizeof(direccionDelCliente));
    
    direccionDelCliente.sin_addr.s_addr      = inet_addr("127.0.0.1");
    direccionDelCliente.sin_port             = htons(2000);
    direccionDelCliente.sin_family           = AF_INET;
    
    if ((SocketDeUDP = socket(AF_INET, SOCK_DGRAM, 0)) < 0) {
        perror ("Ocurrió un error el socket no pudo crearse");
        exit(1);
    }
    if(connect(SocketDeUDP, (struct sockaddr *) &direccionDelCliente, sizeof(direccionDelCliente)) < 0){
        printf("\n Error: el intento de conexión falló \n");
        exit(0);
    }

    sendto(SocketDeUDP, mensajeParaElServidor, 255, 0, (struct sockaddr *) NULL, sizeof(direccionDelCliente));
    printf("Mensaje enviado al servidor. \n");
    recvfrom(SocketDeUDP, mensajeRecibido, sizeof(mensajeRecibido), 0, (struct sockaddr *) NULL, NULL);
    printf("Respuesta del Servidor: ");
    puts(mensajeRecibido);
    close(SocketDeUDP);
}