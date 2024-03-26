#include "2_23 and later - cabeceras de red.h"

int main() {
    printf("Configurando direccion local...\n");
    struct addrinfo hints;
    memset(&hints, 0, sizeof(hints));
    hints.ai_family = AF_INET;                  // por favor seleccione AF_INET para ipv4 o AF_INET6 para ipv6 según corresponda
    hints.ai_socktype = SOCK_DGRAM;
    hints.ai_flags = AI_PASSIVE;

    struct addrinfo *bind_address;
    getaddrinfo(0, "8080", &hints, &bind_address);

    printf("Creando el socket...\n");
    int socket_listen;
    socket_listen = socket(bind_address->ai_family, bind_address->ai_socktype, bind_address->ai_protocol);
    if (!(socket_listen)) {
        fprintf(stderr, "ocurrió un fallo con socket() (%d)\n");
        return 1;
    }

    printf("conectando el socket a la direccion local...\n");
    if (bind(socket_listen, bind_address->ai_addr, bind_address->ai_addrlen)) {
        fprintf(stderr, "ocurrio un fallo con bind() (%d)\n");
        return 1;
    }
    freeaddrinfo(bind_address);

    struct sockaddr_storage client_address;
    socklen_t client_len = sizeof(client_address);
    char read [1024];
    int bytes_received = recvfrom(socket_listen, read, 1024, 0, (struct sockadrr*) &client_address, &client_len);

    printf("Recibidos (%d bytes): %.*s\n", bytes_received, bytes_received, read);

    printf("La direccion remota es: ");
    char address_buffer[100];
    char service_buffer[100];
    getnameinfo(((struct sockaddr*) &client_address),
            client_len,
            address_buffer, sizeof(address_buffer),
            service_buffer, sizeof(service_buffer),
            NI_NUMERICHOST | NI_NUMERICSERV);
    printf("%s %s\n", address_buffer, service_buffer);

    close(socket_listen);

    printf("Finalizado.\n");
    return 0;

}