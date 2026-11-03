# 12 — Procedures II: Interfaces, Generics, Procedure Arguments

Making the compiler check every call, giving one name to many procedures,
and treating procedures as values.

## Examples

| File | Topic |
|---|---|
| [01_explicit_interfaces.f90](01_explicit_interfaces.f90) | When an explicit interface is required; interface blocks |
| [02_abstract_interfaces.f90](02_abstract_interfaces.f90) | `abstract interface`, `procedure(iface)` |
| [03_dummy_procedures.f90](03_dummy_procedures.f90) | Procedures as arguments; internal procedures as closures |
| [04_procedure_pointers.f90](04_procedure_pointers.f90) | `procedure(iface), pointer`, pointer components, `nopass` |
| [05_generic_interfaces.f90](05_generic_interfaces.f90) | Overloading by type, kind and rank |
| [06_operator_overloading.f90](06_operator_overloading.f90) | `interface operator(+)`, `.pct.`, elemental operators |
| [07_assignment_overloading.f90](07_assignment_overloading.f90) | `interface assignment(=)` |
| [08_ambiguous_generic.f90](08_ambiguous_generic.f90) | A generic that must fail to compile |
| [09_intrinsic_as_argument.f90](09_intrinsic_as_argument.f90) | `intrinsic`, `external`, passing `sin` |

## Interface block forms

```fortran
interface                     ! specific interfaces (external procedures)
  subroutine ext(x) ... end subroutine
end interface

abstract interface            ! named signatures
  real function fn(x) ... end function
end interface

interface name                ! generic name
  module procedure a, b       ! module procedures
  procedure c                 ! any procedure with explicit interface
end interface

interface operator(+)         ! intrinsic or .defined. operator
interface assignment(=)       ! defined assignment
interface read(formatted)     ! defined I/O (chapter 20)
```

## Declaring procedure entities

| Declaration | Meaning |
|---|---|
| `procedure(iface) :: f` | dummy (or external) procedure with interface `iface` |
| `procedure(iface), pointer :: p => null()` | procedure pointer |
| `procedure(iface), pointer, nopass :: op` | procedure pointer component |
| `external :: f` | external, implicit interface (avoid) |
| `intrinsic :: sin` | refers to the intrinsic |

## Key points

- Module procedures get explicit interfaces for free; hand-written
  interface blocks are for external and C procedures.
- Generic resolution happens at compile time by type, kind and rank;
  specifics must be distinguishable even with optional arguments.
- Operator specifics are functions with `intent(in)` arguments;
  assignment specifics are subroutines `(out/inout, in)`.
- Defining `==` also defines `.eq.`.
- Internal procedures can be passed as arguments and see host variables
  (gfortran builds a stack trampoline for this).
- Only specific intrinsic names can be passed as actual arguments.
