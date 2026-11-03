# 20 — Unlimited Polymorphism and Defined I/O

`class(*)` values of any type, run-time type inquiry, type-erased
containers, and user-defined I/O for derived types.

## Examples

| File | Topic |
|---|---|
| [01_class_star.f90](01_class_star.f90) | `class(*)` dummies and boxes, `select type` on intrinsic types |
| [02_type_inquiry.f90](02_type_inquiry.f90) | `same_type_as`, `extends_type_of` |
| [03_heterogeneous_container.f90](03_heterogeneous_container.f90) | A list of values of any type (+ gfortran 15 caveats) |
| [04_defined_io_write.f90](04_defined_io_write.f90) | `write(formatted)`, `dt`, `dt"iotype"`, `dt(w,d)` |
| [05_defined_io_read.f90](05_defined_io_read.f90) | `read(formatted)` with validation through `iostat` |
| [06_defined_io_unformatted.f90](06_defined_io_unformatted.f90) | Binary I/O of types with allocatable components |

## Defined I/O interfaces

```fortran
generic :: write(formatted)   => wf     ! also read(formatted)
generic :: write(unformatted) => wu     ! also read(unformatted)

subroutine wf(dtv, unit, iotype, v_list, iostat, iomsg)
  class(t), intent(in)            :: dtv      ! intent(inout) for read
  integer, intent(in)             :: unit
  character(*), intent(in)        :: iotype   ! 'LISTDIRECTED', 'NAMELIST', 'DT...'
  integer, intent(in)             :: v_list(:)
  integer, intent(out)            :: iostat
  character(*), intent(inout)     :: iomsg

subroutine wu(dtv, unit, iostat, iomsg)   ! unformatted: no iotype / v_list
```

| Edit descriptor | `iotype` | `v_list` |
|---|---|---|
| list-directed `*` | `'LISTDIRECTED'` | `[]` |
| namelist | `'NAMELIST'` | `[]` |
| `dt` | `'DT'` | `[]` |
| `dt"compact"` | `'DTcompact'` | `[]` |
| `dt(8,3)` | `'DT'` | `[8, 3]` |

## Key points

- `class(*)` accepts anything; only `select type` can use the value.
- Wrap `class(*), allocatable` in a type to build heterogeneous arrays.
- `same_type_as` / `extends_type_of` work on extensible derived types only.
- Defined I/O procedures write with child statements on `unit` and must
  set `iostat`; errors propagate to the parent statement.
- Defined unformatted I/O is the way to serialise types with allocatable
  components.

## gfortran 15 caveats found while writing this chapter

- Reallocating an array whose elements have `class(*), allocatable`
  components (`items = [items, new]`) crashes at run time.
- `move_alloc` of a `class(*)` value holding a character loses its length.

Both are standard-conforming; the example uses a fixed-capacity array
to stay portable.
