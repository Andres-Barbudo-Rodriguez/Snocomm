#include <mach/mach.h>
#include <stdio.h>

void check_error(kern_return_t kr, const char *operation) {
	if (kr != KERN_SUCCESS) {
		fprintf(stderr, "Error en %s: %s (0x%x)\n", operation, mach_error_string(kr), kr);
		exit(1);
	}
}

int main() {
	kern_return_t kr;
	mach_port_t send_once_port;

	kr = mach_port_allocate(mach_task_self(), MACH_PORT_RIGHT_SEND_ONCE, &send_once_port);
	check_error(kr, "mach_port_allocate");

	mach_msg_header_t msg;
	msg.msgh_bits = MACH_MSGH_BITS_SET(MACH_MSG_TYPE_COPY_SEND, 0, 0, 0);
	msg.msgh_size = sizeof(msg);
	msg.msgh_remote_port = send_once_port;
	msg.msgh_local_port = MACH_PORT_NULL;

	kr = mach_msg(&msg, MACH_SEND_MSG, sizeof(msg), 0, MACH_PORT_NULL, MACH_MSG_TIMEOUT_NONE, MACH_PORT_NULL);
	check_error(kr, "mach_msg");

	return 0;
	
