// cabeceras de red

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <unistd.h>
#include <errno.h>

// cabeceras de C

#include <stdio.h>
#include <string.h>
#include <time.h>

int main() {

	printf("Por favor espere, el sistema está configurando la dirección local\n");

	struct addrinfo hints;
	memset(&hints, 0, sizeof(hints));
	hints.ai_family = AF_INET6;
	hints.ai_socktype = SOCK_STREAM;
	hints.ai_flags = AI_PASSIVE;

	struct addrinfo *bind_address;
	getaddrinfo(0, "80", &hints, &bind_address);

	printf("Espere un momento, el sistema está creando el socket...\n");
	int socket_listen;
	socket_listen = socket(bind_address->ai_family, bind_address->ai_socktype, bind_address->ai_protocol);

	printf("Espere un momento, el sistema está conectando el socket a la dirección local...\n");
	if (bind(socket_listen, bind_address->ai_addr, bind_address->ai_addrlen)) {
		fprintf(stderr, "la conexión del socket a la dirección local falló. (%d)\n");
		return 1;
	}
	freeaddrinfo(bind_address);

	printf("Escucha activa...\n");
	if (listen(socket_listen, 10) < 0) {
		fprintf(stderr, "listen() falló. (%d)\n");
		return 1;
	}

	printf("Esperando conexiones entrantes...\n");
	struct sockaddr_storage client_address;
	socklen_t client_len = sizeof(client_address);
	int socket_client = accept(socket_listen, (struct sockaddr*) &client_address, &client_len);

	printf("El cliente se ha conectado...\n");
	char address_buffer[100];
	getnameinfo((struct sockaddr*)&client_address, client_len, address_buffer, sizeof(address_buffer), 0, 0, NI_NUMERICHOST);
	printf("%s\n", address_buffer);

	printf("Espere un momento, el sistema está leyendo su solicitud...\n");						
	char request[1024];
	int bytes_received = recv(socket_client, request, 16384, 0);
	printf("Recibidos %d bytes\n", bytes_received);

	printf("%.*s\n", bytes_received, request);

	printf("Espere un momento, el sistema está enviando la respuesta...\n");
	const char *response =	"HTTP/1.1 200 OK\r\n"
							"Connection: close\r\n"
							"Content-Type: text/plain\r\n\r\n"
							"La fecha local es: ";
	int bytes_sent = send(socket_client, response, strlen(response), 0);
	printf("Enviados %d de %d bytes\n", bytes_sent, (int)strlen(response));

	time_t timer;
	time(&timer);
	char *time_msg = ctime(&timer);
	bytes_sent = send(socket_client, time_msg, strlen(time_msg), 0);
	printf("Enviados %d de %d bytes\n", bytes_sent, (int)strlen(time_msg));

	printf("Conexión finalizada.\n");

	return 0;

}