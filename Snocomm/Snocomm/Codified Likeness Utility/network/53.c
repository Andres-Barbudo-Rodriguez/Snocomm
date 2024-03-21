#include "2_23 and later - cabeceras de red.h"
#include <ctype.h>
#include <Kernel/string.h>
#include <string.h>
#include <strings.h>

int main() {
    printf("configurando direccion local...\n");
    struct addrinfo hints;
    memset(&hints, 0, sizeof(hints));
    hints.ai_family = AF_INET;              // por favor seleccione ipv6 o ipv4 segun corresponda
    hints.ai_socktype = SOCK_STREAM;        // por favor seleccione TCP o UDP según corresponda
    hints.ai_flags = AI_PASSIVE;

    struct addrinfo *bind_address;
    getaddrinfo(0, "8080", &hints, &bind_address);      // por favor seleccione el puerto en el que desea utilizar la escucha

    printf("Creando el socket...\n");
    int socket_listen;
    socket_listen = socket(bind_address->ai_family, bind_address->ai_socktype, bind_address->ai_protocol);

    if (!(socket_listen)) {
        fprintf(stderr, "socket() failed. (%d)\n");
        return 1;
    }

    printf("Conectando el socket con la direccion local...\n");
    if (bind(socket_listen, bind_address->ai_addr, bind_address->ai_addrlen)) {
        fprintf(stderr, "bind() falló. (%d)\n");
        return 1;
    }
    freeaddrinfo(bind_address);

    printf("Escucha activa...\n");
    if (listen(socket_listen, 10) < 0) {
        fprintf(stderr, "listen() falló. (%d)\n");
        return 1;
    }

    fd_set master;
    FD_ZERO(&master);
    FD_SET(socket_listen, &master);
    int max_socket = socket_listen;


    printf("Esperando conexiones...\n");

    while(1) {
        fd_set reads;
        reads = master;
        if (select(max_socket+1, &reads, 0, 0, 0) < 0) {
            fprintf(stderr, "select() falló. (%d)\n");
            return 1;
        }
    

    int i;
    for (i = 1; i <= max_socket; i++) {
        if (FD_ISSET(i, &reads)) {
            if (i == socket_listen) {
                struct sockaddr_storage client_address;
                socklen_t client_len = sizeof(client_address);
                int socket_client = accept(socket_listen, (struct sockaddr*) &client_address, &client_len);

                if(!(socket_client)) {
                    fprintf(stderr, "accept() fallo. (%d)\n");
                    return 1;
                }

                FD_SET(socket_client, &master);
                if (socket_client > max_socket)
                    max_socket = socket_client;
                    char address_buffer[100];
                    getnameinfo((struct sockaddr*) &client_address, client_len,
                                                                address_buffer, sizeof(address_buffer), 0, 0,
                                                                NI_NUMERICHOST);
                    printf("Nueva conexion desde %s\n", address_buffer);

            } else {
                char read[1024];
                int bytes_received = recv(i, read, 1024, 0);
                if (bytes_received < 1) {
                    FD_CLR(i, &master);
                    close(i);
                    continue;
                }

                int j;
                for (j = 1; j <= max_socket; j++) {
                        if (FD_ISSET(j, &master)) {
                            if (j == socket_listen || j == i)
                                continue;
                            else
                                send(j, read, bytes_received, 0);
                        }
                    }
                }
            }
        }
    }
    printf("Finished.\n");
    return 0;
}