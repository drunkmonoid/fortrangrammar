# 100 — Golden Section Search

One-dimensional derivative-free minimisation of `f(x) = (x - 2)^2` on `[0, 5]` via golden-section search.

## Method

- Golden ratio conjugate `phi = 0.5 * (sqrt(5.0) - 1)` is computed once and reuses one interior evaluation per step.
- Stops when the bracket width `b - a <= 1e-3` (within a cap of `30` steps), taking `18` steps from width `5.0`, and verifies `abs(x_min - 2.0) < 0.1`.

## Files

| File | Description |
|---|---|
| [01_golden_section.f90](01_golden_section.f90) | Golden-section minimisation on `[0, 5]` |
