# 14 — Modules

Modules package constants, types, variables and procedures, give every
procedure an explicit interface, and control what is visible to users.

## Examples

| File | Topic |
|---|---|
| [01_module_basics.f90](01_module_basics.f90) | Module layout, module variables, module procedures |
| [02_use_only_rename.f90](02_use_only_rename.f90) | `use, only:`, renaming names and operators, clashes |
| [03_accessibility.f90](03_accessibility.f90) | `private` default, `public` API, re-exporting |
| [04_protected.f90](04_protected.f90) | `protected`: read-only outside the module |
| [05_module_state.f90](05_module_state.f90) | Global state vs. objects |
| [06_intrinsic_modules.f90](06_intrinsic_modules.f90) | The five intrinsic modules, `intrinsic`/`non_intrinsic` |
| [07_extending_generics.f90](07_extending_generics.f90) | Adding specifics to another module's generic |
| [08_multi_file/](08_multi_file/) | Three-file build in dependency order (`build.sh`) |

## Module template

```fortran
module name
  use, intrinsic :: iso_fortran_env, only: dp => real64
  use other_module, only: thing
  implicit none (type, external)
  private
  public :: api_type, api_procedure

  type :: api_type
    ...
  end type

  integer, protected :: read_only_state = 0

contains

  subroutine api_procedure(...)
  end subroutine
end module name
```

## USE forms

| Form | Effect |
|---|---|
| `use m` | all public entities |
| `use m, only: a, b` | only `a`, `b` |
| `use m, x => a` | all, `a` renamed to `x` |
| `use m, only: x => a` | only `a`, as `x` |
| `use m, only: operator(+), assignment(=)` | generic operators/assignment |
| `use m, only: operator(.p.) => operator(.add.)` | rename a defined operator |
| `use, intrinsic :: m` / `use, non_intrinsic :: m` | choose standard vs. user module |

## Key points

- Start every module with `implicit none (type, external)` and `private`.
- Always `use ..., only:` — dependencies stay visible and clashes rare.
- Name clashes are errors only when the ambiguous name is referenced.
- Module variables are global and saved; expose them as `protected` or
  through procedures.
- A module must be compiled before its users; `.mod` files are
  compiler-specific build artefacts.
- Generics are open: other modules can extend them.
