#include <stdio.h>
#include <gmp.h>

int main() {
    mpz_t numero;
    mpz_init(numero);
    mpz_set_str(numero, "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890", 10);

    // Imprime el número como una cadena de caracteres
    gmp_printf("Cadena: %Zd\n", numero);

    mpz_clear(numero);

    return 0;
}
