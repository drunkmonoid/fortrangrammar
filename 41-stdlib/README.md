# 41 — stdlib

A longer look at the Fortran standard library than
[30-ecosystem/07_stdlib_example.f90](../30-ecosystem/07_stdlib_example.f90).
stdlib is not part of the ISO standard. `build.sh` compiles one program
against the installed modules and exits 77 when they are not on the
search path. Set `STDLIB_INC` to the directory that holds the `.mod`
files if they are not in the compiler's default path.

Each call is a convenience over something earlier chapters already do.

| Call | Without stdlib |
|---|---|
| `solve` | `dgesv` (chapter 43) or the Thomas algorithm (phase 90) |
| `norm` | `norm2` (chapter 09) |
| `mean` | `sum(x) / size(x)` (chapter 09) |
| `optval` | `present` and a default (chapter 11) |
| `to_string` | an internal file write (chapter 22) |
| `log_units_assigned` | a unit number you opened yourself (chapter 23) |

## Examples

| File | Topic |
|---|---|
| [01_calls/](01_calls/) | `solve`, `norm`, `mean`, `optval`, `to_string`, a logger |
