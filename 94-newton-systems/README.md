# 94 — Newton Systems

Multidimensional Newton-Raphson iteration solves a nonlinear system $F(v) = 0$
by repeatedly solving the linearised step $J(v_k)\,\Delta v_k = -F(v_k)$ using the
analytic Jacobian $J(v)$ and updating $v_{k+1} = v_k + \Delta v_k$.

If the Jacobian becomes singular ($\det J \approx 0$), the step solver signals
an error via `stat = -1` rather than dividing by zero.

## Examples

| File | Topic |
|---|---|
| [01_newton.f90](01_newton.f90) | 2×2 Newton-Raphson solver with analytic Jacobian and singularity guard |
