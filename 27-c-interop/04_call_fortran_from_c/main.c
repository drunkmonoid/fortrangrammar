/* main.c - a C program using a Fortran library. */
#include <stdio.h>
#include "flib.h"

int main(void) {
    double v[4];
    f_hello();
    f_fill(v, 4, 2.0);
    printf("v = %.1f %.1f %.1f %.1f\n", v[0], v[1], v[2], v[3]);
    printf("f_norm(v) = %.4f\n", f_norm(v, 4));
    printf("Fortran counter seen from C: %d\n", f_counter);
    return 0;
}
