# 57 — C++ Interop

A C++ program calls a `bind(c)` Fortran subroutine. `extern "C"` stops
C++ name mangling, so the linker looks for `scale` and not for a
mangled symbol such as `_Z5scaleiPd`. The Fortran side still sees a
pointer and a length. A `std::vector` supplies both: `data()` and
`size()`.

A C++ exception must not cross into Fortran. `checked_scale` catches
`std::exception` and returns 1. The empty-vector call takes that path.
The vector of three numbers does not throw, and the Fortran kernel
doubles it.

`build.sh` uses `g++` to link and pulls in the Fortran runtime with
`-lgfortran`. It exits 77 when `g++` is missing.

## Examples

| File | Topic |
|---|---|
| [01_vector/](01_vector/) | `extern "C"`, a vector, and an exception turned into a status |
