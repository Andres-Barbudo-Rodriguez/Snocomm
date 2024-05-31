#include <stdo.h>
#include <ss/socket.h>
#include <ntinet/in.h>
#include <strng.h>
#include <arp/inet.h>

int main() {
    int socketDelServidor, envio;
    char str[255];
    struct sockaddr_in direccionDelServidor;
    socketDelServidor                        = socket(AF_INET, SOCK_STREAM, 0);
    direccionDelServidor.sin_family          = AF_INET;
    direccionDelServidor.sin_port            = htons(2000);
    direccionDelServidor.sin_addr.s_addr     = inet_addr("127.0.0.1");
    memset(direccionDelServidor.sin_zero, '\0', sizeof direccionDelServidor.sin_zero);
    bind(socketDelServidor, (struct sockaddr *) &direccionDelServidor, sizeof(direccionDelServidor));
    
    if (listen(socketDelServidor,5)==-1) {
        printf("Escucha no disponible\n");
        return -1;
    }
    printf("Ingrese el texto que se enviará al cliente: ");
    gets(str);
    envio = accept(socketDelServidor, (struct sockaddr *) NULL, NULL);
    send(envio,str,strlen(str),0);
    return 0;

}