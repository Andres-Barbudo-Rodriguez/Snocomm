#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

#define max 50

int main () {
    char str[max];
    int pp[2];

    if (pipe (pp) < 0)
        exit(1);
    printf("ingrese el primer mensaje para el operador de redirección: ");
    gets(str);
    write (pp[1], str, max);
    printf("ingrese el segundo mensaje para el operador de redirección: ");
    gets(str);
    write(pp[1], str, max);
    printf("la lectura desde el operador de redirección es la siguiente:\n");
    read(pp[0], str, max);
    printf("%s\n",str);
    read(pp[0],str,max);
    printf("%s\n", str);
    return 0;
}
