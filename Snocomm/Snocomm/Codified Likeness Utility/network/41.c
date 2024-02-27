// Implementación de un esquema de firma digital basado en retículos (Lattice-based)
// Utiliza la biblioteca de código abierto NTRUEncrypt
// El usuario genera continuamente claves de firma y firma mensajes

#include <stdio.h>
#include <ntru_crypto.h>

int main() {
    // Inicialización
    NTRU_IGF2E_params params = NTRU_DEFAULT_PARAMS_128_BITS;
    NtruEncryptKeyPair kp;
    NtruRandContext rand_ctx;
    ntru_rand_init(&rand_ctx, NTRU_RNG_DEFAULT);

    // Generar continuamente pares de claves de firma
    while (1) {
        ntru_rand_generate((uint8_t *)&kp, sizeof(kp), &rand_ctx);
        if (ntru_encrypt_keygen(&params, &kp, &rand_ctx) != NTRU_SUCCESS) {
            printf("Error al generar claves\n");
            continue;
        }

        // Firma de mensaje de ejemplo
        const uint8_t message[] = "Mensaje de ejemplo";
        uint16_t message_len = strlen((char *)message);
        uint8_t signature[NTRU_MAX_ENCRYPT_LEN];
        uint16_t signature_len;
        if (ntru_sign(message, message_len, &kp.priv, signature, &signature_len, &rand_ctx) != NTRU_SUCCESS) {
            printf("Error al firmar el mensaje\n");
            continue;
        }

        // Verificar firma
        if (ntru_verify(message, message_len, signature, signature_len, &kp.pub) != NTRU_SUCCESS) {
            printf("Error al verificar la firma\n");
            continue;
        }

        printf("Firma verificada con éxito\n");
    }

    ntru_rand_release(&rand_ctx);
    return 0;
}
