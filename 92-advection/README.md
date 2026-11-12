# 92 — Advection Equation

The 1-D linear advection equation $u_t + u_x = 0$ with periodic boundary conditions
is discretised using the first-order upwind scheme:

$$u_i^{n+1} = u_i^n - C \left(u_i^n - u_{i-1}^n\right), \quad C = \frac{\Delta t}{\Delta x}$$

Choosing $\Delta t = \Delta x$ sets the Courant number $C = 1$, where the upwind stencil
exhibits zero numerical dissipation and shifts the initial square pulse by exactly
one cell per time step.

## Examples

| File | Topic |
|---|---|
| [01_advection.f90](01_advection.f90) | Periodic first-order upwind advection at Courant number $C = 1$ |
