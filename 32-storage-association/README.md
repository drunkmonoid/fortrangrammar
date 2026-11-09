# 32 — Storage Association

`common`, `equivalence` and `block data` make variables share memory by
position. They are obsolescent since Fortran 2018. gfortran 15 compiles
them under `-std=f2023 -pedantic` and warns. Nothing checks that two units
describe the same `common` block in the same way.

## Examples

| File | Topic |
|---|---|
| [01_common.f90](01_common.f90) | A named `common` block with the same layout in both subroutines |
| [02_common_mismatch.f90](02_common_mismatch.f90) | The second unit declares fewer variables, so every name shifts |
| [03_equivalence.f90](03_equivalence.f90) | `equivalence (a(2), b(1))` overlays two arrays |
| [04_block_data.f90](04_block_data.f90) | `block data` initialises a `common` block |

## What replaces them

| Old form | Modern form | Chapter |
|---|---|---|
| `common` for shared state | A module variable | 14 |
| `common` for a record of values | A derived type | 16 |
| `equivalence` overlay | One array, with an index, or `transfer` when the point is the bits | 26 |
| `block data` | Initialisation of a module variable (that implies `save`) | 04, 14 |

`sequence` types (chapter 16) are the remaining standard way to require a
storage order. Prefer them only at a C or file boundary.
