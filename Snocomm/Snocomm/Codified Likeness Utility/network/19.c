#include <stdio.h>
#include <time.h>

int main() {
	time_t timer;
	time(&timer);

	printf("La fecha local es: %s\n", ctime(&timer));

	return 0;
}