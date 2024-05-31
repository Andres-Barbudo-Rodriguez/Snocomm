#include <stdo.h>
#include <ss/stat.h>
#include <fctl.h>
#include <unisd.h>

int main() {
    int escritura;
    char str[255];
    mkfifo("RedireccionDeIPC", 0666);
    escritura = open("RedireccionDeIPC", O_WRONLY);
    printf("Enter text: ");
    gets(str);
    write(escritura,str, sizeof(str));
    close(escritura);
    return 0;
}