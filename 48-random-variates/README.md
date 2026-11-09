# 48 — Random Variates

`random_number` returns a uniform value on `[0, 1)`. The generator and the
meaning of a seed are processor-dependent (chapter 24), so this chapter
does not print the draws. It checks properties that hold for a working
generator and prints logicals.

Box–Muller turns two uniforms into a standard normal. A discrete sampler
inverts a two-point distribution. Two seeds must not produce the same
first draw. A Monte Carlo average of `x` on `[0, 1]` estimates `1/2`.

## Examples

| File | Topic |
|---|---|
| [01_variates.f90](01_variates.f90) | Normals, a discrete sampler, two streams, a Monte Carlo integral |
