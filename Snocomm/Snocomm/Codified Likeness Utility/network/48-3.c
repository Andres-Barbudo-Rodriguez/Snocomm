#include <stdio.h>
#include <openssl/rsa.h>
#include <openssl/pem.h>

int main() {
    RSA *rsa_private_key = NULL;

    rsa_private_key = PEM_read_RSAPrivateKey(stdin, NULL, NULL, NULL);

    if (!rsa_private_key) {
        printf("Error al leer la clave privada\n");
        return 1;
    }

    // Decriptar el valor
    unsigned char encrypted[16777216]; // Cambiar el tamaño según sea necesario
    // Llenar 'encrypted' con la clave de sesión encriptada

    unsigned char decrypted[256]; // Cambiar el tamaño según sea necesario
    int decrypted_length = RSA_private_decrypt(256, encrypted, decrypted, rsa_private_key, RSA_PKCS1_PADDING);
    if (decrypted_length == -1) {
        printf("Error al decriptar\n");
        return 1;
    }

    printf("Valor decriptado: %s\n", decrypted);

    RSA_free(rsa_private_key);

    return 0;
}
