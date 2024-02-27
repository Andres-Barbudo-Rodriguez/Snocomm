#include <stdio.h>
#include <openssl/rsa.h>
#include <openssl/pem.h>

#define MAX_SIZE 256

int main() {
    // Cargar la clave pública desde un archivo PEM
    FILE *clave_publica_archivo = fopen("clave_publica.pem", "r");
    RSA *clave_publica = PEM_read_RSA_PUBKEY(clave_publica_archivo, NULL, NULL, NULL);
    fclose(clave_publica_archivo);

    if (!clave_publica) {
        printf("Error al cargar la clave pública\n");
        return 1;
    }

    // Mensaje a encriptar
    unsigned char mensaje[MAX_SIZE] = "Hola, mundo!";
    int mensaje_len = strlen(mensaje);

    // Buffer para almacenar el mensaje encriptado
    unsigned char mensaje_encriptado[MAX_SIZE];

    // Encriptar el mensaje utilizando la clave pública RSA
    int encriptado_len = RSA_public_encrypt(mensaje_len, mensaje, mensaje_encriptado, clave_publica, RSA_PKCS1_PADDING);
    if (encriptado_len == -1) {
        printf("Error al encriptar el mensaje\n");
        RSA_free(clave_publica);
        return 1;
    }

    // Imprimir el mensaje encriptado (en formato hexadecimal)
    printf("Mensaje encriptado: ");
    for (int i = 0; i < encriptado_len; ++i) {
        printf("%02X", mensaje_encriptado[i]);
    }
    printf("\n");

    // Descifrar el mensaje encriptado
    unsigned char mensaje_descifrado[MAX_SIZE];
    int descifrado_len = RSA_public_decrypt(encriptado_len, mensaje_encriptado, mensaje_descifrado, clave_publica, RSA_PKCS1_PADDING);
    if (descifrado_len == -1) {
        printf("Error al descifrar el mensaje\n");
        RSA_free(clave_publica);
        return 1;
    }

    // Imprimir el mensaje descifrado
    printf("Mensaje descifrado: %s\n", mensaje_descifrado);

    RSA_free(clave_publica);
    return 0;
}
