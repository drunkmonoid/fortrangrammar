# 95 — Least Squares

Fits a linear model $y = a + b x$ to data points by assembling the $2 \times 2$
normal equations $X^T X \beta = X^T y$ and solving them with direct Gaussian
elimination in pure Fortran.

For production overdetermined problems with ill-conditioned design matrices, see
Chapter 43 (LAPACK QR/SVD least squares).

## Examples

| File | Topic |
|---|---|
| [01_least_squares.f90](01_least_squares.f90) | Linear fit via normal equations and 2×2 elimination |
