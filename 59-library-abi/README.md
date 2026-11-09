# 59 — Library ABI

The public surface is `bind(c)` only. The Fortran module is an
implementation detail: a C caller includes `scale.h` and never sees a
`.mod` file. `library_version` returns an integer so a caller can refuse
a library that is too old. `build.sh` builds a shared object and links a
C driver against that header alone.

A patch release can change the body of `scale`. It cannot change:

- argument order, or which arguments are passed by value
- the hidden length that a `character` argument would add (this library
  passes none)
- the assumption that the array is contiguous and 1-based in Fortran,
  which is 0-based in C

## Examples

| File | Topic |
|---|---|
| [01_shared/](01_shared/) | A versioned shared library and a C driver |
