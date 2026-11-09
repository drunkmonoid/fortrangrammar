# 34 — Deleted Features

These forms are no longer part of Fortran. `-std=f2023` rejects them.
gfortran still parses them under `-std=legacy`, which is a later flag
than the default `-std=f2023` (see [CONVENTIONS.md](../CONVENTIONS.md)).

The legacy file is compiled and not run. Two of the forms do not survive
execution on gfortran 15: `pause` waits for stdin, and
`do x = 1.0, 2.0` does not terminate.

## Examples

| File | Topic |
|---|---|
| [01_deleted_features.f90](01_deleted_features.f90) | Must fail to compile with the default flags |
| [02_deleted_features_legacy.f90](02_deleted_features_legacy.f90) | The same source, `@flags -std=legacy`, `@run no` |

## What was deleted, and what to write instead

| Deleted form | Removed in | Write this |
|---|---|---|
| `assign` and assigned `go to` | Fortran 95 | `select case`, or a procedure pointer (chapter 12) for a chosen format |
| `pause` | Fortran 95 | `read` a line, or `error stop` (chapter 06) |
| Arithmetic `if (x) 10, 20, 30` | Fortran 2018 | `if` / `else if` on the sign (chapter 06) |
| A real variable as a `do` index | Fortran 95 | An integer `do`, and a real computed from it |
| Shared `do` termination (one label, nested loops) | Fortran 2018 | Nested block `do`s (chapter 06) |

gfortran 15 reports each of these as a deleted feature. The messages are
quoted in `01_deleted_features.f90`.
