#include "2_23 and later - cabeceras de red.h"

int main(int argc, char *argv[]) {
    if (argc < 3) {
        fprintf(stderr, "modo de uso cliente_tcp_2 host puerto\n");
        return 1;
    }

    printf("configurando dirección remota...\n");
    struct addrinfo hints;
    memset(&hints, 0, sizeof(hints));
    hints.ai_socktype = SOCK_DGRAM;
    struct addrinfo *peer_address;
    if (getaddrinfo(argv[1], argv[2], &hints, &peer_address)) {
        fprintf(stderr, "getaddrinfo() failed. (%d)\n");
    }

    printf("La dirección remota es: ");
    char address_buffer[100];
    char service_buffer[100];
    getnameinfo(peer_address->ai_addr, peer_address->ai_addrlen, 
        address_buffer, sizeof(address_buffer), 
        service_buffer, sizeof(service_buffer), NI_NUMERICHOST);
    printf("%s %s\n", address_buffer, service_buffer);

    printf("creando el socket...\n");
    int socket_peer;
    socket_peer = socket(peer_address->ai_family,
                        peer_address->ai_socktype, peer_address->ai_protocol);

    printf("Conectando...\n");
    if (connect(socket_peer, peer_address->ai_addr,
                            peer_address->ai_addrlen)) {
                                fprintf(stderr, "connect() falló. (%d)\n");
                                return 1;
                            }
    freeaddrinfo(peer_address);     // garbage collection

    while(1) {
        fd_set reads;
        FD_ZERO(&reads);
        FD_SET(socket_peer, &reads);

        struct timeval timeout;
        timeout.tv_sec = 0;
        timeout.tv_usec = 100000;

        if (select(socket_peer+1, &reads, 0, 0, &timeout) < 0) {
            fprintf(stderr, "select() falló. (%d)\n");
            return 1;
        }

        if (FD_ISSET(socket_peer, &reads)) {
            char read[4096];
            int bytes_received = recv(socket_peer, read, 4096, 0);
            if (bytes_received < 1) {
                printf("Conexión cerrada por el peer.\n");
                break;
            }
            printf("Recibidos (%d bytes): %.*s", bytes_received, bytes_received, read);
        }

        char read[4096];
        if (!fgets(read, 4096, stdin)) break;
        printf("Enviando: %s", read);
        int bytes_sent = send(socket_peer, read, strlen(read), 0);
        printf("Enviados %d bytes.\n", bytes_sent);
    }
    printf("cerrando el socket...\n");
    close(socket_peer);

    printf("Finalizado.\n");
    return 0;

}