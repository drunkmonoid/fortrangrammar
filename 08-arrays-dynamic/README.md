# 08 — Arrays II: Dynamic Arrays and Array Arguments

Arrays whose size is decided at run time, and every way an array can be
passed to a procedure.

## Examples

| File | Topic |
|---|---|
| [01_allocatable_basics.f90](01_allocatable_basics.f90) | `allocate`, `deallocate`, `allocated`, `stat=`, `errmsg=`, auto-free |
| [02_allocate_source_mold.f90](02_allocate_source_mold.f90) | `source=`, `mold=`, scalar fill |
| [03_realloc_on_assignment.f90](03_realloc_on_assignment.f90) | Automatic (re)allocation; `a(:) =` suppresses it |
| [04_move_alloc.f90](04_move_alloc.f90) | `move_alloc` and a growable vector |
| [05_explicit_shape_dummies.f90](05_explicit_shape_dummies.f90) | `a(n, m)` dummies, sequence association, copy-in/out |
| [06_assumed_shape.f90](06_assumed_shape.f90) | `a(:)` dummies — the modern default |
| [07_assumed_size.f90](07_assumed_size.f90) | `a(*)` dummies (legacy interfaces) |
| [08_automatic_arrays.f90](08_automatic_arrays.f90) | Locals sized from arguments; stack caveats |
| [09_allocatable_dummies_results.f90](09_allocatable_dummies_results.f90) | `allocatable, intent(out/inout)`, allocatable results |
| [10_assumed_rank.f90](10_assumed_rank.f90) | `a(..)` and `select rank` |
| [11_contiguous.f90](11_contiguous.f90) | `contiguous`, `is_contiguous` |

## Kinds of array declaration

| Form | Declaration | Shape known | Typical use |
|---|---|---|---|
| explicit shape | `a(10)`, `a(n, m)` | compile time / from args | locals, legacy dummies |
| automatic | `work(size(x))` (local) | on entry | scratch space |
| deferred shape | `allocatable :: a(:)`, `pointer :: p(:)` | after allocation | dynamic data |
| assumed shape | `a(:)` (dummy) | from actual arg | **default for dummies** |
| assumed size | `a(*)` (dummy) | not known | BLAS/LAPACK style |
| assumed rank | `a(..)` (dummy) | rank at run time | rank-generic code, C interop |
| implied shape | `parameter :: a(*) = [...]` | from initialiser | constants |

## Allocatable checklist

```fortran
real, allocatable :: a(:)
allocate (a(n), stat=ios, errmsg=msg)   ! handle failure yourself
a = [a, x]                              ! realloc on assignment (O(n) copy)
a(:) = 0                                ! no realloc: shapes must conform
call move_alloc(tmp, a)                 ! steal storage, no copy
if (allocated(a)) deallocate (a)        ! usually unnecessary: auto-freed
```

## Key points

- Prefer `allocatable` over `pointer` for dynamic size: no leaks, no aliasing.
- Locals (without `save`) are deallocated automatically at the end of
  their procedure or `block`.
- Assumed-shape dummies need an explicit interface: put procedures in modules.
- Inside a procedure, assumed-shape dummies have lower bound 1 unless
  declared `a(lo:)`.
- Passing non-contiguous sections to explicit-shape or `contiguous`
  dummies makes a temporary copy.
- `intent(out)` allocatable dummies are deallocated on entry.
- Large automatic arrays can overflow the stack — use allocatables.
