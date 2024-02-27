// Implementación de un esquema de firma digital basado en códigos
// Utiliza la biblioteca de código abierto Picnic
// El usuario genera continuamente claves de firma y firma mensajes

#include <stdio.h>
#include <picnic.h>

int main() {
    // Inicialización
    const picnic_instance_t *instance = Picnic_L1_FS;
    const size_t max_signature_size = picnic_signature_size(instance);
    uint8_t private_key[PICNIC_PRIVATE_KEY_SIZE];
    uint8_t public_key[PICNIC_PUBLIC_KEY_SIZE];
    uint8_t plaintext[] = "Mensaje de ejemplo";
    uint8_t signature[max_signature_size];

    // Generar continuamente claves de firma
    while (1) {
        picnic_keygen(instance, private_key, public_key);

        // Firma de mensaje de ejemplo
        if (picnic_sign(instance, private_key, plaintext, sizeof(plaintext), signature, &max_signature_size) != PICNIC_SUCCESS) {
            printf("Error al firmar el mensaje\n");
            continue;
        }

        // Verificar firma
        if (picnic_verify(instance, public_key, plaintext, sizeof(plaintext), signature, max_signature_size) != PICNIC_SUCCESS) {
            printf("Error al verificar la firma\n");
            continue;
        }

        printf("Firma verificada con éxito\n");
    }

    return 0;
}
