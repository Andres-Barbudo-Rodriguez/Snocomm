#include <mach/mach.h>
#include <stdio.h>

void check_error(kern_return_t kr, const char *operation){
	if (kr != KERN_SUCCESS) {
		fprintf(stderr, "Error %s: %s (0x%x)\n", operation, mach_error_string(kr), kr);
		exit(1);
	}
}

int main() {
	kern_return_t kr;
	mach_port_t port;

	kr = mach_port_allocate(mach_task_self(), MACH_PORT_RIGHT_SEND, &port);
	check_error(kr, "mach_port_allocate");

	kr =mach_port_deallocate(mach_task_self(), port);
	check_error(kr, "mach_port_deallocate");

	return 0;
}
