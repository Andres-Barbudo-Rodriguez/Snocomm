#include <stdio.h>
#include <openssl/rsa.h>
#include <openssl/pem.h>
#include <openssl/bio.h>

int main() {
    RSA *rsa_private_key = NULL;
    FILE *fp = fopen("private_key.pem", "rb"); // Asegúrate de tener la clave privada en un archivo "private_key.pem"
    if (!fp) {
        printf("Error al abrir el archivo de clave privada\n");
        return 1;
    }

    rsa_private_key = PEM_read_RSAPrivateKey(fp, NULL, NULL, NULL);
    fclose(fp);

    if (!rsa_private_key) {
        printf("Error al leer la clave privada\n");
        return 1;
    }

    // Decriptar el valor
    unsigned char encrypted[256]; // Cambiar el tamaño según sea necesario
    // Llenar 'encrypted' con la clave de sesión encriptada

    BIO *bio = BIO_new_mem_buf(encrypted, -1);
    unsigned char decrypted[256]; // Cambiar el tamaño según sea necesario
    int decrypted_length = RSA_private_decrypt(BIO_pending(bio), encrypted, decrypted, rsa_private_key, RSA_PKCS1_PADDING);
    if (decrypted_length == -1) {
        printf("Error al decriptar\n");
        return 1;
    }

    printf("Valor decriptado: %s\n", decrypted);

    RSA_free(rsa_private_key);

    return 0;
}
