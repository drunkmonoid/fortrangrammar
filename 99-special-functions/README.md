# 99 — Special Functions

Pure-Fortran truncated Taylor series for `exp(1)` and `erf(x)` without any external special-function library.

## Series Details

- `exp(1)` is evaluated using `12` terms (`k = 0..11`), whose remainder is well below `1e-6`, and checked against Fortran's intrinsic `exp(1.0_real64)`.
- `erf(x)` uses a `12`-term Maclaurin series with `x = 0` returning exact `0.0_real64`.

## Files

| File | Description |
|---|---|
| [01_special_functions.f90](01_special_functions.f90) | Truncated series approximations for `exp(1)` and `erf(0)` |
