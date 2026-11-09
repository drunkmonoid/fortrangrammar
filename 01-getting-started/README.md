# 01 — Getting Started

How to compile Fortran, what a program looks like, and the one line every
program unit should contain.

## Examples

| File | Topic |
|---|---|
| [01_hello_world.f90](01_hello_world.f90) | Smallest complete program |
| [02_program_anatomy.f90](02_program_anatomy.f90) | Parts of a program unit and their required order |
| [03_implicit_none.f90](03_implicit_none.f90) | `implicit none`, `(type)`, `(type, external)` |
| [04_implicit_typing_trap.f90](04_implicit_typing_trap.f90) | What goes wrong without it |
| [05_implicit_none_external_error.f90](05_implicit_none_external_error.f90) | A program that must fail to compile |
| [06_list_directed_io.f90](06_list_directed_io.f90) | `print`, `write`, `read`, `iostat`, standard units |
| [07_program_units.f90](07_program_units.f90) | Main program, module, external subprogram |
| [08_compiler_inquiry.f90](08_compiler_inquiry.f90) | `compiler_version()`, `compiler_options()` |
| [compilers.md](compilers.md) | Compilers, flags, file extensions |

## Compiling by hand

```sh
gfortran -std=f2023 -Wall -Wextra -pedantic -fcheck=all -g -fbacktrace \
         hello.f90 -o hello
./hello
```

Or, inside this repository:

```sh
scripts/run.sh 01-getting-started/01_hello_world.f90
scripts/check_all.sh 01-getting-started     # every example in the chapter
```

## Which "modern Fortran"

| Standard | ISO | Highlights |
|---|---|---|
| Fortran 2003 | 1539-1:2004 | OOP, C interop, IEEE modules, allocatable components |
| Fortran 2008 | 1539-1:2010 | Coarrays, submodules, `do concurrent`, `block` |
| Fortran 2018 | 1539-1:2018 | Teams/events, assumed rank, `select rank`, `implicit none (external)` |
| **Fortran 2023** | **1539-1:2023** | Conditional expressions, enumeration types, `typeof`, `split`/`tokenize`, degree trig, `simple` procedures |

This tutorial teaches the language as defined by **Fortran 2023**. Each file
notes when a feature was introduced only where that matters for compiler
support. Fortran 2023 is a superset of 2018 except for a short list of
deleted and obsolescent features. Chapters 31–34 are those forms, and
what to write instead.

## Statement order inside a program unit

```
program / module / subroutine / function heading
  use ...                    ┐
  import ...                 │  specification part
  implicit none (...)        │
  declarations, interfaces   ┘
  executable statements         execution part (not in modules)
contains
  internal / module procedures
end program / module / ...
```

All declarations precede the first executable statement. To declare
variables later, open a `block` construct (chapter 06).

## `implicit none (type, external)`

Without an `implicit` statement, undeclared names are silently typed by their
first letter (`I`–`N` integer, everything else real). Always switch this off:

```fortran
implicit none (type, external)
```

- `type` — every variable must be declared.
- `external` — every external procedure needs an interface or the
  `external` attribute, so argument mismatches are caught at compile time.

It is inherited by contained procedures and `block` constructs, but **not** by
interface bodies.

## Key points

- Free-form source, file extension `.f90` (any standard; the number is not the
  language version). `.F90` means "run the preprocessor first".
- Fortran is case-insensitive: `PRINT`, `Print` and `print` are the same.
- `print *` / `write (*, *)` use list-directed formatting; exact layout is
  compiler-dependent. Use an explicit format when the layout matters.
- Use `iso_fortran_env` names (`output_unit`, `error_unit`, `input_unit`)
  instead of the numbers 6, 0 and 5.
- Prefer modules over external procedures: module procedures get explicit
  interfaces automatically.
