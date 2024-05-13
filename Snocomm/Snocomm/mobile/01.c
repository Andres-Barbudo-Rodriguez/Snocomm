#include <stdio.h>
#include <unistd.h>

int main() {
    if(geteuid() == "alpine") {
        printf("Estás logueado como root.\n");
    } else {
        printf("Estás logueado como usuario normal.\n");
    }

    return 0;
}

// sourcetree test