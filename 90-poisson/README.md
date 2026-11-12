# 90 — Poisson Equation

Discretising the 1-D Poisson boundary-value problem
$$-u''(x) = 1, \quad u(0) = u(1) = 0$$
with second-order finite differences on $n = 3$ interior grid points ($h = 0.25$)
produces a symmetric tridiagonal linear system solved in $O(n)$ operations by the
**Thomas algorithm** (tridiagonal matrix algorithm, TDMA).

Because the exact analytical solution $u(x) = x(1-x)/2$ is quadratic, the second-difference
discretisation has zero truncation error and recovers the exact values
$[3/32, 4/32, 3/32]$.

## Examples

| File | Topic |
|---|---|
| [01_poisson.f90](01_poisson.f90) | 1-D Poisson equation solved directly with the Thomas algorithm |
