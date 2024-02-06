// cabeceras de C

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

// cabeceras de red

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <unistd.h>
#include <errno.h>
#include <time.h>
#include <openssl/ssl.h>
#include <openssl/err.h>

#define PORT "8080" // Puerto en el que escucha el servidor

void *get_in_addr(struct sockaddr *sa) {
    if (sa->sa_family == AF_INET) {
        return &(((struct sockaddr_in*)sa)->sin_addr);
    }
    return &(((struct sockaddr_in6*)sa)->sin6_addr);
}

int main() {
    int status;
    struct addrinfo hints;
    struct addrinfo *servinfo, *p;
    int sockfd;
    struct sockaddr_storage their_addr;
    socklen_t addr_len;
    char s[INET6_ADDRSTRLEN];
    char buffer[100];

    memset(&hints, 0, sizeof hints);
    hints.ai_family = AF_UNSPEC; // Permitir tanto IPv4 como IPv6
    hints.ai_socktype = SOCK_STREAM;
    hints.ai_flags = AI_PASSIVE; // Usar mi IP

    // Obtener información de direcciones
    if ((status = getaddrinfo(NULL, PORT, &hints, &servinfo)) != 0) {
        fprintf(stderr, "getaddrinfo: %s\n", gai_strerror(status));
        return 1;
    }

    // Iterar sobre los resultados y enlazar al primer socket posible
    for(p = servinfo; p != NULL; p = p->ai_next) {
        if ((sockfd = socket(p->ai_family, p->ai_socktype, p->ai_protocol)) == -1) {
            perror("server: socket");
            continue;
        }

        if (bind(sockfd, p->ai_addr, p->ai_addrlen) == -1) {
            close(sockfd);
            perror("server: bind");
            continue;
        }

        break;
    }

    if (p == NULL) {
        fprintf(stderr, "server: error al enlazar\n");
        return 2;
    }

    freeaddrinfo(servinfo); // Ya no necesitamos esta estructura

    // Escuchar conexiones entrantes
    if (listen(sockfd, 10) == -1) {
        perror("listen");
        exit(1);
    }

    printf("Servidor de fecha local: esperando conexiones...\n");

    SSL_CTX *ctx;
    SSL *ssl;
    const SSL_METHOD *method;

    SSL_load_error_strings();
    OpenSSL_add_ssl_algorithms();
    method = TLS_server_method(); /* Create new server-method instance */
    ctx = SSL_CTX_new(method);   /* Create new context */
    if (ctx == NULL) {
        ERR_print_errors_fp(stderr);
        abort();
    }
    SSL_CTX_set_ecdh_auto(ctx, 1);

    while(1) {
        addr_len = sizeof their_addr;
        int new_fd = accept(sockfd, (struct sockaddr *)&their_addr, &addr_len);
        if (new_fd == -1) {
            perror("accept");
            continue;
        }

        inet_ntop(their_addr.ss_family, get_in_addr((struct sockaddr *)&their_addr), s, sizeof s);
        printf("Servidor: conexión desde %s\n", s);

        ssl = SSL_new(ctx);
        SSL_set_fd(ssl, new_fd);

        if (SSL_accept(ssl) <= 0) {
            ERR_print_errors_fp(stderr);
        } else {
            time_t rawtime;
            struct tm *timeinfo;
            time(&rawtime);
            timeinfo = localtime(&rawtime);
            strftime(buffer, sizeof(buffer), "%Y-%m-%d %H:%M:%S", timeinfo);

            SSL_write(ssl, buffer, strlen(buffer));
        }

        SSL_free(ssl);
        close(new_fd);
    }

    SSL_CTX_free(ctx); /* Release context */

    return 0;
}