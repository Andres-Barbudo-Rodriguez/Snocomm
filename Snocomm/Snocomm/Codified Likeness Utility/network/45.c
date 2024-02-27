// Implementación de un esquema de firma digital basado en hash
// Utiliza la biblioteca de código abierto XMSS
// El usuario genera continuamente claves de firma y firma mensajes

#include <stdio.h>
#include <xmss/xmss_core.h>

int main() {
    // Inicialización
    xmss_params params;
    params.func = XMSS_SHA2;
    params.n = 32;
    params.full_height = 20;
    params.tree_height = 10;
    uint32_t pk[XMSS_PARAM_PK_BYTES / sizeof(uint32_t)];
    uint32_t sk[XMSS_PARAM_SK_BYTES / sizeof(uint32_t)];

    // Generar continuamente pares de claves de firma
    while (1) {
        xmss_keygen(&params, pk, sk);

        // Firma de mensaje de ejemplo
        uint8_t message[] = "Mensaje de ejemplo";
        uint8_t signature[XMSS_PARAM_SIG_BYTES];
        xmss_sign(&params, signature, sk, message);

        // Verificar firma
        if (xmss_verify(&params, signature, pk, message) != 0) {
            printf("Error al verificar la firma\n");
            continue;
        }

        printf("Firma verificada con éxito\n");
    }

    return 0;
}
