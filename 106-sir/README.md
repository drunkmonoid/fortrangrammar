# 106 — SIR Epidemic Model

Five explicit Euler steps of the deterministic SIR model with total population `N = 1000`.

## Behaviour

- Starts with `S = 990`, `I = 10`, `R = 0`, `beta = 0.3`, `gamma = 0.1`, `dt = 0.5` for `5` steps.
- Verifies all compartments stay non-negative and `nint(S + I + R) == N`.

## Files

| File | Description |
|---|---|
| [01_sir.f90](01_sir.f90) | Explicit Euler SIR step and population conservation check |
