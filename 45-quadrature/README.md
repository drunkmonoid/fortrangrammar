# 45 — Quadrature and Roots

Two classic numerical tasks written with `pure` functions and no library:
integrate a polynomial, and find a root. The checks are yes-or-no so the
output does not depend on a decimal expansion of an irrational number.

## Examples

| File | Topic |
|---|---|
| [01_quadrature.f90](01_quadrature.f90) | Trapezoid and Simpson on x² over [0, 1] |
| [02_roots.f90](02_roots.f90) | Bisection and Newton on x² − 2 |

Simpson's rule is exact for quadratics, so the integral of x² is a real
test and not only a checksum. Newton and bisection both have to land
inside a fixed tolerance of √2; the program prints whether they did.
