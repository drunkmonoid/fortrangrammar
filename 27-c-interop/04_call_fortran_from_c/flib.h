/* flib.h - C prototypes for the Fortran library in flib.f90. */
#ifndef FLIB_H
#define FLIB_H
extern int f_counter;                              /* bind(c) module variable */
double f_norm(const double *x, int n);
void   f_fill(double *x, int n, double value);
void   f_hello(void);
#endif
