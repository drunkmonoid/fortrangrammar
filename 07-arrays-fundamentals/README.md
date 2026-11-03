# 07 — Arrays I: Fundamentals

Fixed-size arrays: declaring, constructing, indexing, slicing and
operating on them as whole objects. Dynamic arrays and array arguments are
in chapter 08; the library of array intrinsics is chapter 09.

## Examples

| File | Topic |
|---|---|
| [01_declaring_arrays.f90](01_declaring_arrays.f90) | Rank, bounds, extent, shape, size, zero-sized, rank 15 |
| [02_array_constructors.f90](02_array_constructors.f90) | `[ ]`, `(/ /)`, type-spec, implied-do, empty arrays |
| [03_element_order.f90](03_element_order.f90) | Column-major storage, `reshape(order=)` |
| [04_sections.f90](04_sections.f90) | Triplets, strides, reversal, vector subscripts |
| [05_whole_array_ops.f90](05_whole_array_ops.f90) | Element-wise operators, broadcasting, conformance |
| [06_where.f90](06_where.f90) | `where` / `elsewhere`, `merge` |
| [07_multidimensional.f90](07_multidimensional.f90) | Matrices, loop order, `dim=` reductions |

## Indexing cheat sheet

| Expression | Meaning |
|---|---|
| `a(i)` | element |
| `a(lo:hi)` | elements `lo..hi` |
| `a(lo:hi:s)` | stride `s` (negative = backwards) |
| `a(:)` / `a(lo:)` / `a(:hi)` | all / from `lo` / up to `hi` |
| `m(i, :)` | row `i` (rank 1) |
| `m(:, j)` | column `j` (rank 1) |
| `a([3, 1, 2])` | vector subscript |
| `a(5:4)` | zero-sized section |

## Inquiry

| Function | Result |
|---|---|
| `size(a [, dim])` | number of elements (in a dimension) |
| `shape(a)` | extents as a rank-1 array |
| `lbound(a [, dim])`, `ubound(a [, dim])` | bounds |
| `rank(a)` | number of dimensions (F2018) |

## Key points

- Lower bound defaults to 1; any integer bounds are allowed.
- Arrays are **column-major**: loop over the first index innermost.
- Constructors are rank 1; `reshape` makes higher ranks.
- Character constructors with mixed lengths need `[character(len=n) :: …]`.
- Sections always have lower bound 1.
- Whole-array operations are element-wise; `matmul` is the matrix product.
- Shapes must conform; `-fcheck=all` catches mismatches at run time.
- `where` evaluates elemental operations only where the mask holds;
  `merge` evaluates everything.
- `forall` is obsolescent since F2018: use `do concurrent` (chapter 28).
