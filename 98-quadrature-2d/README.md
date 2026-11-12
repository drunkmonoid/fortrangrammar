# 98 — Quadrature in Two Dimensions

Product composite Simpson's rule over the unit square `[0, 1] x [0, 1]` for `f(x, y) = x^2 + y^2`, whose exact integral is `2/3`.

## Method

- Panel counts: `4` panels (`5` nodes) along `x` and `4` panels (`5` nodes) along `y`, reusing the composite Simpson weight pattern from chapter 45.
- Checks `abs(approx - 2/3) < 1e-6` and prints the logical result.

## Files

| File | Description |
|---|---|
| [01_quadrature_2d.f90](01_quadrature_2d.f90) | 2-D product Simpson quadrature checked against `2/3` |
