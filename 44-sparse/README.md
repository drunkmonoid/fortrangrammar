# 44 — Sparse Matrices

Coordinate (COO) and compressed sparse row (CSR) storage, a matrix-vector
product, and Jacobi, with no sparse library. The matrix is the 3×3
second-difference

```
 2 -1  0
-1  2 -1
 0 -1  2
```

and the vectors are small enough that every printed integer is exact.

## Examples

| File | Topic |
|---|---|
| [01_csr_matvec.f90](01_csr_matvec.f90) | COO to CSR, then y = A x for x = [1, 2, 3] |
| [02_jacobi.f90](02_jacobi.f90) | Two Jacobi steps from zero toward a known right-hand side |

`01` prints the CSR row pointers `[1, 3, 6, 8]` and `y = [0, 0, 4]`.
`02` solves nothing to completion: after two iterations from zero the
vector is `[0.5, 0, 0.5]`, and the program prints twice that.
