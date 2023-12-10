#include <mach/mach.h>
#include <stdio.h>
#include <unistd.h>

void check_error(kern_return_t kr, const char *operation) {
    if (kr != KERN_SUCCESS) {
        fprintf(stderr, "Error en %s: %s (0x%x)\n", operation, mach_error_string(kr), kr);
        exit(1);
    }
}

int main() {
    kern_return_t kr;
    mach_port_t dead_name_port;

    // Crear un puerto normal
    mach_port_t normal_port;
    kr = mach_port_allocate(mach_task_self(), MACH_PORT_RIGHT_RECEIVE, &normal_port);
    check_error(kr, "mach_port_allocate");

    // Crear un puerto dead name
    kr = mach_port_allocate(mach_task_self(), MACH_PORT_RIGHT_DEAD_NAME, &dead_name_port);
    check_error(kr, "mach_port_allocate");

    // Hacer que el puerto normal sea un dead name
    kr = mach_port_destroy(mach_task_self(), normal_port);
    check_error(kr, "mach_port_destroy");

    // Verificar si el puerto normal es un dead name
    mach_port_type_t port_type;
    kr = mach_port_type(mach_task_self(), normal_port, &port_type);
    check_error(kr, "mach_port_type");

    if (port_type & MACH_PORT_TYPE_DEAD_NAME) {
        printf("El puerto normal es un dead name.\n");
    } else {
        printf("Error: El puerto normal no es un dead name.\n");
    }

    // Liberar el puerto normal (ya que no se hace automáticamente después de destruirlo)
    kr = mach_port_deallocate(mach_task_self(), normal_port);
    check_error(kr, "mach_port_deallocate");

    // Liberar el puerto dead name
    kr = mach_port_deallocate(mach_task_self(), dead_name_port);
    check_error(kr, "mach_port_deallocate");

    return 0;
}

