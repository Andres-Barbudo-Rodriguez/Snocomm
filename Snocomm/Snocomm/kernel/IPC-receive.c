#include <mach/mach.h>
#include <stdio.h>

void check_error(kern_return_t kt, const char *operation) {
	if (kr != KERN_SUCCESS) {
		fprintf(stderr, "Error en %s: %s (0x%x)\n", operation, mach_error_string(kr), kr);
		exit(1);
	}
}


int main() {
	kern_return_t kr;
	mach_port_t port;

	kr = mach_port_allocate(mach_task_self(), MACH_PORT_RIGHT_RECEIVE, &port);
	check_error(kr, "mach_port_allocate");

	mach_msg_header_t ms;
	mach_msg_return_t msg_result;

	msg.msg_size = sizeof(msg);
	msg_result = mach_msg(&msg, MACH_RCV_MSG, 0, sizeof(msg), port, MACH_MSG_TIMEOUT_NONE, MACH_PORT_NULL);
	
	if (msg_result != MACH_MSG_SUCCESS) {
		fprintf(stderr, "Error al recibir el mensaje: %s (0x%x)\n", mach_error_string(msg_result), msg_result);
		exit(1);
}
