# 103 — Two-Body Euler Step

One explicit Euler step for a unit-gravitational-parameter circular orbit starting at `r = (1, 0)`, `v = (0, 1)`.

## Behaviour

- Acceleration is `a = -r / |r|^3` (`-r` at unit radius).
- `dt = 0.0` leaves the orbital radius identically `1.0`.
- `dt = 0.1` yields radius `sqrt(1.01) ~ 1.005`, within `0.05` of `1`.

## Files

| File | Description |
|---|---|
| [01_two_body.f90](01_two_body.f90) | Single-step two-body explicit Euler integration check |
