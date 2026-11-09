# 40 — Floating-Point Practice

What binary floating point actually does with the numbers people write,
on top of the inquiry functions in chapter 25. The default flags do not
include `-O3` or `-ffast-math`, so the results below are the IEEE
evaluations. Adding `-ffast-math` lets the compiler reassociate and
contract expressions; rebuild `01_decimal_fractions.f90` with that flag
before trusting a bit-identical sum.

## Examples

| File | Topic |
|---|---|
| [01_decimal_fractions.f90](01_decimal_fractions.f90) | `0.1` is not a dyadic; `0.5` is |
| [02_fused_multiply_add.f90](02_fused_multiply_add.f90) | `ieee_fma` rounds once |

## What changes under `-ffast-math`

`-ffast-math` permits the compiler to turn `a*b+c` into a fused
multiply-add, and to add a loop in a different order. A sum of `0.1`
ten times is the case that moves. A sum of `0.5`, `0.25` and `0.125`
does not: each of those values, and their total, is exactly
representable.
