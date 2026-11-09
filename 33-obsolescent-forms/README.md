# 33 — Obsolescent Forms That Still Compile

Procedure and control spellings Fortran has kept, with a warning, so that
old source still builds. Each file also runs the modern replacement.
gfortran 15 accepts all of them under `-std=f2023 -pedantic`.

`implicit none (external)` means an external procedure needs an explicit
interface or the `external` attribute. The interfaces below are what that
requires; a Fortran 77 caller had neither.

## Examples

| File | Topic | Modern replacement |
|---|---|---|
| [01_statement_functions.f90](01_statement_functions.f90) | One-line functions in the specification part | Internal function (chapter 11) |
| [02_entry.f90](02_entry.f90) | Several procedure names, one body | Module procedures sharing private state (chapter 14) |
| [03_alternate_return.f90](03_alternate_return.f90) | `call sub(*10)` / `return 1` | An integer status |
| [04_computed_goto.f90](04_computed_goto.f90) | `go to (10, 20, 30), k` | `select case` (chapter 06) |
| [05_forall.f90](05_forall.f90) | `forall` | `do concurrent` (chapter 28) |
| [06_labelled_do.f90](06_labelled_do.f90) | `do 10 i = 1, n` | A block `do` (chapter 06) |

## Rules that are easy to miss

- A statement function is one statement in the specification part. Its
  dummy arguments are scalars declared in the host. It cannot be an
  argument, and it cannot be in a module.
- `entry` is an external subprogram only. Every dummy of every entry is
  declared before the first executable statement. `entry` inside a module
  procedure is an error.
- An alternate-return dummy is written `*` in the interface and at the
  call. `return 1` branches to the first label in the call.
- `forall` defines an order of assignments. It does not promise that
  iterations are independent. `do concurrent` does (chapter 28).
- A labelled `do` that ends on `continue` or `end do` is obsolescent and
  legal. Two loops that share one terminal label were deleted in
  Fortran 2018 (chapter 34).
