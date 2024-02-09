#include "boost/asio.hpp"
#include <iostream>

using namespace boost;

int main() {
	std::string raw_ip_address = "127.0.0.1";
	unsigned short port_num = 3333;

	boost:system::error_code ec;

	// representación de direccionamiento en el protocolo IP independiente de version (ipv4 o ipv6)
	asio::ip::address ip_address = asio::ip::address::from_string(raw_ip_address, ec);

	if (ec.value() != 0) {
		// si la dirección IP es inválida, termina la ejecución
		std::cout
		<< "Fallo en el formato de la direccion IP. Codigo de Error = "
		<< ec.value() << ". Mensaje: " << ec.message();
		return ec.value();
	}

	asio::ip::udp::endpoint ep(ip_address, port_num);

	return 0;
}