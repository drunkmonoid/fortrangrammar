#include <stdio.h>
#include "scale.h"

int main(void) {
    double x[3] = {1.0, 2.0, 3.0};
    scale(3, x);
    printf("version = %d\n", library_version());
    printf("x = %d %d %d\n", (int) x[0], (int) x[1], (int) x[2]);
    return 0;
}
