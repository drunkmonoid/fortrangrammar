# 89 — Interpolation

This chapter contrasts piecewise linear and cubic polynomial interpolation on
samples of $f(x) = x^2$ at $x = 0, 1, 2, 3$:

- **Linear interpolation** on the bracket $[1, 2]$ yields $2.5$ at $x = 1.5$:
  monotonically bounded between $1$ and $4$, yet inexact because $f''(x) \neq 0$.
- **Cubic Lagrange interpolation** over the 4-point stencil $[0, 1, 2, 3]$ is
  exact for polynomials up to degree 3, recovering $f(1.5) = 2.25$.

See [74-capstone](../74-capstone/) for a packaged interpolation library with
submodules, tests, and C/Python bindings.

## Examples

| File | Topic |
|---|---|
| [01_interpolation.f90](01_interpolation.f90) | Linear and cubic Lagrange interpolation on $x^2$ |
