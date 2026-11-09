# 46 — Ordinary Differential Equations

Euler and classical fourth-order Runge–Kutta, on the harmonic oscillator,
whose solution is cos(t). No ODE library. The program prints whether each
method landed inside a fixed tolerance of cos(1), so the output does not
depend on printing the approximation itself.

## Example

| File | Topic |
|---|---|
| [01_harmonic.f90](01_harmonic.f90) | y'' = −y, y(0) = 1, y'(0) = 0, integrated to t = 1 |

Euler needs a much smaller step than Runge–Kutta to earn the same
tolerance. The file uses h = 0.1 for Euler and h = 0.2 for Runge–Kutta
and asks less of Euler.
