# 56 — Python Interop

A `bind(c)` subroutine fills a `real64` array. `build.sh` compiles it as
a shared library and calls it from Python with `ctypes` and a NumPy
array. The script exits 77 when `python3` or NumPy is missing.

f2py is the other common path: `python3 -m numpy.f2py -c fill.f90 -m fill`
builds an importable module from a Fortran procedure that is not
`bind(c)`. This chapter runs the `ctypes` path, which needs no extra
build tool.

The array is contiguous and 1-based on the Fortran side. NumPy's buffer
is 0-based and, for a newly allocated `float64` vector, C-contiguous.
Those two layouts match for a rank-1 array.

## Examples

| File | Topic |
|---|---|
| [01_ctypes/](01_ctypes/) | A shared library called from NumPy |
