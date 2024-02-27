#include <stdio.h>
#include <stdlib.h>
#include <gmp.h>

int main() {
    mpz_t numero;
    mpz_init(numero);
    mpz_set_str(numero, "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890", 10);

    // Obtiene la cadena representando el número
    char *cadena = mpz_get_str(NULL, 10, numero);

    // Imprime la cadena
    printf("Cadena: %s\n", cadena);

    // Libera la memoria asignada a la cadena
    free(cadena);
    mpz_clear(numero);

    return 0;
}
