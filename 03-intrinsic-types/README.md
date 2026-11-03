# 03 — Intrinsic Types and Kinds

Fortran has five intrinsic types. Each has a **kind** type parameter that
selects its size or precision; `character` also has a **length** parameter.

## Examples

| File | Topic |
|---|---|
| [01_integer.f90](01_integer.f90) | `integer`, kinds `int8`…`int64`, `huge`, `range`, literal suffixes |
| [02_real.f90](02_real.f90) | `real`, `real32/64/128`, `selected_real_kind`, the missing-suffix bug |
| [03_complex.f90](03_complex.f90) | `complex`, `cmplx(..., kind=)`, `%re`/`%im` |
| [04_logical.f90](04_logical.f90) | `logical`, operators, `.eqv.`, `selected_logical_kind` (F2023) |
| [05_character.f90](05_character.f90) | `character`, `len`, kinds, `len=:` / `len=*`, Unicode |
| [06_kind_arrays.f90](06_kind_arrays.f90) | `integer_kinds`, `real_kinds`, … and negative "unavailable" kinds |
| [07_kinds_module.f90](07_kinds_module.f90) | The working-precision (`wp`) module idiom |
| [08_boz_constants.f90](08_boz_constants.f90) | `b'…'`, `o'…'`, `z'…'` and where they are allowed |
| [09_type_conversion.f90](09_type_conversion.f90) | `int`, `nint`, `floor`, `ceiling`, `real`, `cmplx` with `kind=` |

## The five types

| Type | Example declaration | Literal examples |
|---|---|---|
| `integer` | `integer(int64) :: n` | `42`, `42_int64`, `int(z'ff')` |
| `real` | `real(real64) :: x` | `1.0`, `1.5e-3_real64`, `2.0d0` |
| `complex` | `complex(real64) :: z` | `(1.0, -2.0)`, `(1.0_dp, 0.0_dp)` |
| `logical` | `logical :: flag` | `.true.`, `.false._logical8` |
| `character` | `character(len=10) :: s` | `'text'`, `"it's"`, `ucs4_'text'` |

`double precision` is a sixth spelling for a real kind; it is not a separate
type. Prefer `real(real64)`.

## Choosing kinds

```fortran
use, intrinsic :: iso_fortran_env, only: int32, int64, real32, real64, real128
integer, parameter :: wp  = real64                    ! fixed size
integer, parameter :: dp  = selected_real_kind(15, 307) ! by precision/range
integer, parameter :: i8  = selected_int_kind(18)      ! by decimal digits
integer, parameter :: ucs4 = selected_char_kind('ISO_10646')
integer, parameter :: lk  = selected_logical_kind(8)   ! F2023, by bits
```

- Never write literal kind numbers (`real(8)`, `integer*4`): they are not
  portable, and `type*n` is not standard at all.
- Kind constants are negative when the kind does not exist (e.g. `real16`
  in gfortran 15 is `-2`).
- Complex kinds are the real kinds.

## Inquiry functions used here

| Function | Answers |
|---|---|
| `kind(x)` | Kind value of `x` |
| `huge(x)` / `tiny(x)` | Largest value / smallest positive normal value |
| `range(x)` | Decimal exponent range |
| `precision(x)` | Decimal digits of precision |
| `digits(x)` | Significant binary digits |
| `epsilon(x)` | Smallest `e` with `1 + e /= 1` |
| `storage_size(x)` | Size in bits |

Chapter 25 covers the numeric model completely.

## Key points

- **Every real literal needs a kind suffix** if the variable is not default
  real: `x = 0.1` stores single-precision 0.1 into a double.
- `cmplx(x, y)` and `real(n)` without `kind=` return **default** kind.
- Integer overflow is undefined behaviour; it is not detected.
- Logicals are not integers; convert with `merge(1, 0, l)` and `n /= 0`.
- BOZ constants are untyped bit patterns; gfortran 15 still needs
  `int(z'ff')` where F2023 would accept a bare `z'ff'`.
