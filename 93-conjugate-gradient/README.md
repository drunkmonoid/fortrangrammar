# 93 — Conjugate Gradient

The Conjugate Gradient (CG) method iteratively solves symmetric positive-definite
linear systems $A x = b$ without matrix factorisations or external BLAS calls.
Unlike stationary Jacobi iteration (Chapter 44), CG constructs $A$-conjugate search
directions and converges in at most $n$ iterations in exact arithmetic for an
$n \times n$ matrix.

## Examples

| File | Topic |
|---|---|
| [01_cg.f90](01_cg.f90) | Pure Fortran CG on the $3 \times 3$ matrix from Chapter 44 |
