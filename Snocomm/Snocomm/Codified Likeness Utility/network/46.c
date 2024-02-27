#include <stdio.h>
#include <stdlib.h>
#include <gmp.h> // Librería GNU MP para operaciones matemáticas de precisión arbitraria

int main() {
    mpz_t numero; // Variable para almacenar el número grande
    mpz_init(numero);

    // Asigna el valor al número grande
    mpz_set_str(numero, "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890", 10);

    // Convierte el número a una cadena de caracteres
    char cadena[200];
    gmp_snprintf(cadena, sizeof(cadena), "%Zd", numero);

    // Imprime la cadena
    printf("Cadena: %s\n", cadena);

    mpz_clear(numero); // Liberar la memoria asignada a la variable mpz_t

    return 0;
}
