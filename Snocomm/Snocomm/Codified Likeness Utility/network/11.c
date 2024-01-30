#include <stdio.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

int main() {
    int fw;
    char str[255];
    mkfifo("RedireccionDeIPC", 0666);
    fw = open("RedireccionDeIPC", O_WRONLY);
    printf("Enter text: ");
    gets(str);
    write(fw,str, sizeof(str));
    close(fw);
    return 0;
}