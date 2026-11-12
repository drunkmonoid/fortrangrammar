#ifndef INTERP1D_H
#define INTERP1D_H

#ifdef __cplusplus
extern "C" {
#endif

void interp1d_linear(int n, const double *x, const double *y,
                     int nq, const double *xq, double *yq, int *stat);

#ifdef __cplusplus
}
#endif

#endif
