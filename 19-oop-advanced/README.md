# 19 — OOP II: Abstract Types, Generic Bindings, Finalization

Interfaces as types, overloading inside types, destructors and common
design patterns.

## Examples

| File | Topic |
|---|---|
| [01_abstract_types.f90](01_abstract_types.f90) | `type, abstract`, `deferred` bindings, template method |
| [02_non_overridable.f90](02_non_overridable.f90) | `non_overridable` (must fail to compile) |
| [03_generic_bindings.f90](03_generic_bindings.f90) | `generic :: log => log_int, log_real, ...` |
| [04_type_bound_operators.f90](04_type_bound_operators.f90) | `generic :: operator(+)`, `assignment(=)`, `pass(v)` |
| [05_finalization.f90](05_finalization.f90) | `final ::` — when it runs, rank-specific finals, order |
| [06_factory_and_strategy.f90](06_factory_and_strategy.f90) | Factory function, strategy component |

## Binding attributes

```fortran
type, abstract :: base
contains
  procedure(iface), deferred      :: must_implement
  procedure, non_overridable      :: fixed
  procedure, private              :: helper
  procedure, pass(obj)            :: with_obj_second
  procedure, nopass               :: static
  generic :: name          => spec_a, spec_b
  generic :: operator(+)   => add
  generic :: assignment(=) => assign
  generic :: write(formatted) => write_fmt     ! chapter 20
  final   :: destroy                           ! concrete types only
end type
```

## When `final` runs

| Event | Finalized |
|---|---|
| `deallocate(x)` | yes |
| end of procedure / `block` (non-saved local) | yes |
| `x = expr` (intrinsic assignment) | old value of `x` |
| `intent(out)` dummy, on entry | yes |
| function result, after use | yes |
| main program / module variables at program end | **no** |
| structure constructor temporaries | no (since F2018) |

For extended types the child's finalizer runs first, then the parent's.

## Key points

- Abstract types cannot be instantiated; concrete extensions must
  implement every deferred binding.
- Make specific bindings private and expose a generic.
- Type-bound operators travel with the type — no `use, only: operator(...)`.
- Final subroutines take `type(t)`, not `class(t)`; give one per rank or
  make it elemental.
- Polymorphic allocatable results make factories trivial and leak-free.
