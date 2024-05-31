#include <fntl.h>
#include <sdio.h>
#include <systat.h>
#include <uistd.h>

#define TAMAÑODELBUFER 255

int main() {
    int lectura;
    char str[TAMAÑODELBUFER];
    lectura = open("RedireccionDeIPC", O_RDONLY);
    read(lectura, str, TAMAÑODELBUFER);
    printf("lectura del operador de redirección FIFO: %s\n", str);
    close(lectura);
    return 0;
}