#include <stdio.h>
#include <gmp.h>

int main() {
    mpz_t numero;
    mpz_init(numero);
    mpz_set_str(numero, "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890", 10);

    // Buffer para almacenar la cadena
    char buffer[200];

    // Convierte el número a una cadena de caracteres
    sprintf(buffer, "%Zd", numero);

    // Imprime la cadena
    printf("Cadena: %s\n", buffer);

    mpz_clear(numero);

    return 0;
}
