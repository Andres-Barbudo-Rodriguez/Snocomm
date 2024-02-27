#include <stdio.h>
#include <tomcrypt.h>

int main() {
    // Inicialización de LibTomCrypt
    register_all_ciphers();
    register_all_hashes();

    // Cargar la clave pública desde un archivo DER
    FILE *clave_publica_archivo = fopen("clave_publica.der", "rb");
    rsa_key clave_publica;
    int carga_clave = rsa_import(clave_publica_archivo, &clave_publica);
    fclose(clave_publica_archivo);

    if (carga_clave != CRYPT_OK) {
        printf("Error al cargar la clave pública\n");
        return 1;
    }

    // Mensaje a encriptar
    unsigned char mensaje[] = "Hola, mundo!";
    unsigned long mensaje_len = strlen(mensaje);

    // Buffer para almacenar el mensaje encriptado
    unsigned char mensaje_encriptado[4096];
    unsigned long encriptado_len = sizeof(mensaje_encriptado);

    // Encriptar el mensaje utilizando la clave pública RSA
    int encriptado = rsa_encrypt_key_ex(mensaje, mensaje_len, mensaje_encriptado, &encriptado_len, NULL, 0, NULL, find_prng("sprng"), find_hash("sha1"), 8, &clave_publica);
    if (encriptado != CRYPT_OK) {
        printf("Error al encriptar el mensaje\n");
        rsa_free(&clave_publica);
        return 1;
    }

    // Imprimir el mensaje encriptado (en formato hexadecimal)
    printf("Mensaje encriptado: ");
    for (unsigned long i = 0; i < encriptado_len; ++i) {
        printf("%02X", mensaje_encriptado[i]);
    }
    printf("\n");

    // Liberar la clave pública
    rsa_free(&clave_publica);

    return 0;
}
