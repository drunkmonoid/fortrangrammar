# 09 — Array Intrinsics

The standard library of whole-array functions. Learn these and most loops
disappear.

## Examples

| File | Topic |
|---|---|
| [01_reductions.f90](01_reductions.f90) | `sum`, `product`, `maxval`, `minval`, `count`, `any`, `all` |
| [02_location.f90](02_location.f90) | `maxloc`, `minloc`, `findloc`, `back=` |
| [03_construction.f90](03_construction.f90) | `reshape`, `spread`, `pack`, `unpack`, `merge` |
| [04_manipulation.f90](04_manipulation.f90) | `cshift`, `eoshift`, `transpose` |
| [05_linear_algebra.f90](05_linear_algebra.f90) | `matmul`, `dot_product`, `norm2` |
| [06_bitwise_and_parity.f90](06_bitwise_and_parity.f90) | `iall`, `iany`, `iparity`, `parity` |
| [07_reduce.f90](07_reduce.f90) | `reduce` with a user operation (F2018) |

## Reference

| Intrinsic | Arguments | Result |
|---|---|---|
| `sum`, `product` | `(array [, dim] [, mask])` | numeric reduction |
| `maxval`, `minval` | `(array [, dim] [, mask])` | extreme value |
| `count` | `(mask [, dim] [, kind])` | number of `.true.` |
| `any`, `all` | `(mask [, dim])` | logical OR / AND |
| `parity` | `(mask [, dim])` | logical XOR |
| `iall`, `iany`, `iparity` | `(array [, dim] [, mask])` | bitwise AND / OR / XOR |
| `norm2` | `(x [, dim])` | Euclidean norm |
| `maxloc`, `minloc` | `(array [, dim] [, mask] [, kind] [, back])` | subscripts (from 1) |
| `findloc` | `(array, value [, dim] [, mask] [, kind] [, back])` | subscripts (from 1) |
| `reshape` | `(source, shape [, pad] [, order])` | new shape |
| `spread` | `(source, dim, ncopies)` | rank + 1 |
| `pack` | `(array, mask [, vector])` | rank 1 |
| `unpack` | `(vector, mask, field)` | shape of mask |
| `merge` | `(tsource, fsource, mask)` | elemental choice |
| `cshift` | `(array, shift [, dim])` | circular shift |
| `eoshift` | `(array, shift [, boundary] [, dim])` | end-off shift |
| `transpose` | `(matrix)` | rank 2 |
| `matmul` | `(a, b)` | matrix product |
| `dot_product` | `(a, b)` | inner product (conjugates complex `a`) |
| `reduce` | `(array, operation [, dim] [, mask] [, identity] [, ordered])` | general reduction |

Inquiry functions (`size`, `shape`, `lbound`, `ubound`, `rank`,
`is_contiguous`) are covered in chapters 07 and 08.

## Key points

- `dim=d` removes dimension `d` from the result; `dim=1` on a matrix gives
  one value per column.
- Location functions return subscripts **counted from 1**, ignoring lower
  bounds, and return 0 when nothing matches.
- Without `dim`, location functions return a rank-1 array even for vectors.
- Empty reductions return identities (`0`, `1`, `.false.`, `.true.`,
  most negative/positive value).
- `merge` evaluates both alternatives everywhere.
- Prefer `norm2` over `sqrt(sum(x**2))`: it cannot overflow needlessly.
- `reduce`'s operation must be `pure` and should be associative.
