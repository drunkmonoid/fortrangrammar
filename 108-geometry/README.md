# 108 — Circle-Segment Geometry

Quadratic intersection test between a line segment and the unit circle `x^2 + y^2 = 1` using dyadic coordinates so the discriminant is exact.

## Behaviour

- Segment `(0, 0)` to `(2, 0)` gives discriminant `16 > 0` with root `t = 0.5` in `[0, 1]` -> `hit`.
- Segment `(2, 2)` to `(3, 2)` gives negative discriminant -> `miss`.
- Non-positive discriminants are treated as misses; segment endpoints lying on the unit circle satisfy `t in [0, 1]` and count as hits.

## Files

| File | Description |
|---|---|
| [01_geometry.f90](01_geometry.f90) | Unit-circle segment intersection test |
