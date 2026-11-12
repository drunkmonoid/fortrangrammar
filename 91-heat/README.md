# 91 — Heat Equation

The 1-D heat equation $u_t = u_{xx}$ is solved explicitly with the
Forward-Time Centred-Space (FTCS) scheme:

$$u_i^{n+1} = u_i^n + \frac{\Delta t}{\Delta x^2}\left(u_{i-1}^n - 2u_i^n + u_{i+1}^n\right)$$

Explicit FTCS is conditionally stable under the CFL / von Neumann criterion
$\Delta t / \Delta x^2 \le 1/2$. On a linear initial profile $u(x) = x$, the
discrete second difference is identically zero, leaving interior values invariant.

## Examples

| File | Topic |
|---|---|
| [01_heat.f90](01_heat.f90) | Single explicit FTCS step preserving a linear steady-state profile |
