# 102 — Mandelbrot Escape Iterations

Escape-iteration counts for `z_{k+1} = z_k^2 + c` starting from `z_0 = 0` using `complex(real64)`.

## Test Points (`max_iter = 20`)

1. `(0, 0)` — remains bounded (`0`).
2. `(3, 0)` — escapes on iteration `1` (`|z|^2 = 9 > 4`).
3. `(-1, 0)` — cycles on `-1, 0`, stays bounded (`0`).
4. `(0.5, 0.5)` — escapes on iteration `5`.

## Files

| File | Description |
|---|---|
| [01_mandelbrot.f90](01_mandelbrot.f90) | Mandelbrot escape iteration counter for four complex points |
