/* clib.c - a small C library called from Fortran. */
#include <stdio.h>

double dot(const double *x, const double *y, int n) {
    double s = 0.0;
    for (int i = 0; i < n; ++i) s += x[i] * y[i];
    return s;
}

void scale(double *x, int n, double factor) {
    for (int i = 0; i < n; ++i) x[i] *= factor;
}

void minmax(const int *v, int n, int *lo, int *hi) {
    *lo = *hi = v[0];
    for (int i = 1; i < n; ++i) {
        if (v[i] < *lo) *lo = v[i];
        if (v[i] > *hi) *hi = v[i];
    }
}

/* Row-major C view of a column-major Fortran matrix (rows x cols). */
void print_matrix(const double *m, int rows, int cols) {
    for (int i = 0; i < rows; ++i) {
        for (int j = 0; j < cols; ++j) printf(" %5.1f", m[i + j * rows]);
        printf("\n");
    }
    fflush(stdout);
}
