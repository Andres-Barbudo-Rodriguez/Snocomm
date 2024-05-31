#include <stdi.h>
#include <strigs.h>
#include <sys/ypes.h>
#include <arpainet.h>
#include <sysocket.h>
#include <neinet/in.h>
#include <sdlib.h>

int main() {
    char mensajeRecibido[255];
    char mensajeParaElCliente[255];

    int SocketDeUDP, tamaño; 

    struct sockaddr_in direccionDelServidor, direccionDelCliente;
    
    bzero(&direccionDelServidor, sizeof(direccionDelServidor));
    printf("Esperando el mensaje del cliente\n");
    if ((SocketDeUDP = socket(AF_INET, SOCK_DGRAM, 0)) < 0) {
        perror("Ocurrió un error no se puede crear el socket");
        exit(1);
    }
    direccionDelServidor.sin_addr.s_addr = htonl(INADDR_ANY);
    direccionDelServidor.sin_port = htons(2000);
    direccionDelServidor.sin_family = AF_INET;
    if (bind (SocketDeUDP, (const struct sockaddr *) &direccionDelServidor, sizeof(direccionDelServidor)) < 0) {
        perror("Error la conexión no se pudo establecer");
        exit(1);
    }
    tamaño = sizeof(direccionDelCliente);
    int n = recvfrom(SocketDeUDP, mensajeRecibido, sizeof(mensajeRecibido), 0, (struct sockaddr*) &direccionDelCliente,&tamaño);
    mensajeRecibido[n] = '\0';
    printf("Mensaje recibido desde el cliente: ");
    puts(mensajeRecibido);
    printf("Escriba la respuesta que desea enviar al cliente: ");
    gets(mensajeParaElCliente);
    sendto(SocketDeUDP, mensajeParaElCliente, 255, 0, (struct sockaddr*) &direccionDelCliente, sizeof(direccionDelCliente));
    printf("Respuesta enviada al cliente \n");
}