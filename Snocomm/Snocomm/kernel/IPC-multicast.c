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
    mach_port_t port_set;

    // Crear un conjunto de puertos
    kr = mach_port_allocate(mach_task_self(), MACH_PORT_RIGHT_PORT_SET, &port_set);
    check_error(kr, "mach_port_allocate");

    // Crear varios puertos y agregarlos al conjunto
    mach_port_t port1, port2;
    kr = mach_port_allocate(mach_task_self(), MACH_PORT_RIGHT_RECEIVE, &port1);
    check_error(kr, "mach_port_allocate");

    kr = mach_port_allocate(mach_task_self(), MACH_PORT_RIGHT_RECEIVE, &port2);
    check_error(kr, "mach_port_allocate");

    kr = mach_port_insert_right(mach_task_self(), port1, port1, MACH_MSG_TYPE_MAKE_SEND);
    check_error(kr, "mach_port_insert_right");

    kr = mach_port_insert_right(mach_task_self(), port2, port2, MACH_MSG_TYPE_MAKE_SEND);
    check_error(kr, "mach_port_insert_right");

    mach_port_t ports[2] = {port1, port2};

    kr = mach_port_set_attributes(mach_task_self(), port_set, MACH_PORT_DNREQUESTS, ports, 2);
    check_error(kr, "mach_port_set_attributes");

    // Realizar operaciones con el conjunto de puertos

    // Liberar el conjunto de puertos y los puertos dentro de él
    kr = mach_port_deallocate(mach_task_self(), port_set);
    check_error(kr, "mach_port_deallocate");

    kr = mach_port_deallocate(mach_task_self(), port1);
    check_error(kr, "mach_port_deallocate");

    kr = mach_port_deallocate(mach_task_self(), port2);
    check_error(kr, "mach_port_deallocate");

    return 0;
}

