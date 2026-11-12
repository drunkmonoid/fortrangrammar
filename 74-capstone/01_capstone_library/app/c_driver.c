#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "interp1d.h"

int main(void) {
    double x[] = {0.0, 1.0, 2.0, 4.0};
    double y[] = {0.0, 10.0, 20.0, 40.0};
    double xq[] = {0.5, 1.5, 3.0};
    double yq[3];
    int stat = 0;

    interp1d_linear(4, x, y, 3, xq, yq, &stat);
    if (stat != 0) {
        fprintf(stderr, "interp1d_linear failed with stat %d\n", stat);
        return 1;
    }

    if (fabs(yq[0] - 5.0) > 1e-12 || fabs(yq[1] - 15.0) > 1e-12 || fabs(yq[2] - 30.0) > 1e-12) {
        fprintf(stderr, "C driver verification mismatch: %f %f %f\n", yq[0], yq[1], yq[2]);
        return 1;
    }

    printf("C driver interpolation verified: %0.1f %0.1f %0.1f\n", yq[0], yq[1], yq[2]);
    return 0;
}
