# 67 — Fypp

[Fypp](https://github.com/aradi/fypp) is a Python-powered preprocessor designed specifically
for Fortran codebases. It is widely used across modern libraries (such as `stdlib` and `test-drive`)
to implement generic programming before the standardization of Fortran 202Y templates.

This chapter demonstrates how to generate kind-generic kernels cleanly using:
- `#:set` and `#:for` loops over intrinsic kinds (`real32`, `real64`, `real128`)
- `#:def` macros to define repetitive routine signatures and bodies
- Inline evaluation `${...}$` to substitute type names and procedure identifiers

`build.sh` invokes `fypp` to expand `axpy.fypp` into Fortran 2023 code inside the build
directory and compiles it. Exits with status 77 when `fypp` is not installed.
The generated code expansion is also recorded in comments inside `axpy.fypp`.

## Examples

| Directory | Topic |
|---|---|
| [01_axpy/](01_axpy/) | Kind-generic AXPY module generated using fypp macros and loops |
