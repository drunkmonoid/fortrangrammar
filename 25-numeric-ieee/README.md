# 25 — Numeric Model and IEEE Arithmetic

What the processor's numbers look like, how to inspect them, and the
IEEE 754 modules for special values, exceptions and rounding.

## Examples

| File | Topic |
|---|---|
| [01_numeric_inquiry.f90](01_numeric_inquiry.f90) | `radix`, `digits`, `precision`, `range`, `epsilon`, `huge`, `tiny`, exponents |
| [02_real_manipulation.f90](02_real_manipulation.f90) | `exponent`, `fraction`, `scale`, `spacing`, `nearest`, `rrspacing`, ULPs |
| [03_ieee_classes_values.f90](03_ieee_classes_values.f90) | NaN, ±Inf, −0, subnormals, `ieee_class`, `ieee_is_*` |
| [04_ieee_exceptions.f90](04_ieee_exceptions.f90) | The five flags, `ieee_get_flag`, halting |
| [05_ieee_rounding.f90](05_ieee_rounding.f90) | Rounding modes, interval bounds, `ieee_rint` |
| [06_ieee_operations.f90](06_ieee_operations.f90) | `ieee_next_after`, `ieee_rem`, `ieee_fma`, `ieee_max_num`, quiet compares |
| [07_ieee_features.f90](07_ieee_features.f90) | `ieee_features`, `ieee_support_*` |
| [08_floating_point_pitfalls.f90](08_floating_point_pitfalls.f90) | Summation order, Kahan, cancellation, tolerances |

## The three IEEE modules

| Module | Provides |
|---|---|
| `ieee_exceptions` | `ieee_flag_type` (`ieee_overflow`, `ieee_divide_by_zero`, `ieee_invalid`, `ieee_underflow`, `ieee_inexact`, `ieee_usual`, `ieee_all`), get/set flag, halting mode, status save/restore |
| `ieee_arithmetic` | everything in `ieee_exceptions`, plus classes and values, rounding modes, `ieee_is_*`, `ieee_copy_sign`, `ieee_next_after`, `ieee_rem`, `ieee_rint`, `ieee_logb`, `ieee_scalb`, `ieee_fma`, min/max, comparisons, `ieee_support_*` |
| `ieee_features` | named constants that request IEEE features |

## Compiler support (gfortran 15)

| Feature | Standard | Status |
|---|---|---|
| classes, values, flags, halting, rounding modes | F2003 | ✅ |
| `ieee_fma`, `ieee_signbit`, `ieee_max_num` family, quiet/signaling compares | F2018 | ✅ |
| `ieee_rint(x, round)`, `ieee_real`, `ieee_int`, `ieee_next_up/down` | F2018 | ❌ |
| `ieee_max`, `ieee_min`, `ieee_max_mag`, `ieee_min_mag` | F2023 | ❌ |

## Key points

- `tiny` is the smallest *normal* number; subnormals go below it.
- `spacing(x)` is the ULP at `x`; compare values in ULPs or with a
  relative tolerance, never with `==`.
- NaN is unequal to everything, itself included — test with `ieee_is_nan`.
- Flags and the rounding mode are restored on return from a procedure.
- Constant folding hides run-time exceptions; use `volatile` in tests.
- Floating-point addition is not associative: summation order matters.
- Avoid `-ffast-math` for numerically sensitive code.
