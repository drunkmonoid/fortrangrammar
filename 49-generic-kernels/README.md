# 49 — Generic Kernels

One axpy body, three kinds, no templates. The executable statement lives
in `axpy_body.inc` and is included into a subroutine per kind. A generic
interface publishes a single name. This is the pattern the Fortran
standard library used before templates. Phase 67 generates the same
kernel with fypp instead of maintaining the three wrappers by hand.

## Example

| File | Topic |
|---|---|
| [01_axpy.f90](01_axpy.f90) | `y = a*x + y` for `real32`, `real64` and `real128` |
| [axpy_body.inc](axpy_body.inc) | The statement those three subroutines share |

`real128` here is gfortran's 16-byte real. The values in the driver are
small integers, so every kind produces the same checksum.
