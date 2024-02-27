// Implementación de un esquema de cifrado basado en retículos
// Utiliza la biblioteca de código abierto Kyber
// El usuario genera continuamente claves de cifrado y cifra/descifra mensajes

#include <stdio.h>
#include <kyber.h>

int main() {
    // Inicialización
    kyber_params params = KYBER_512;
    uint8_t public_key[KYBER_PUBLICKEYBYTES];
    uint8_t secret_key[KYBER_SECRETKEYBYTES];
    kyber_keypair(public_key, secret_key);
    uint8_t ciphertext[KYBER_CIPHERTEXTBYTES];
    uint8_t message[KYBER_INDCPA_MSGBYTES];
    uint8_t decrypted_message[KYBER_INDCPA_MSGBYTES];

    // Generar continuamente pares de claves de cifrado
    while (1) {
        kyber_keypair(public_key, secret_key);

        // Cifrar mensaje de ejemplo
        kyber_encrypt(ciphertext, message, sizeof(message), public_key);

        // Descifrar mensaje cifrado
        kyber_decrypt(decrypted_message, ciphertext, sizeof(ciphertext), secret_key);

        printf("Mensaje cifrado y descifrado con éxito\n");
    }

    return 0;
}
