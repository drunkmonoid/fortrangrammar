# 74 — Capstone

This capstone project synthesizes modern Fortran features into a cohesive,
production-ready scientific numerical library:

- **Modules and Submodules (Chapters 14–15)**: Clear separation of public API interface
  (`interp1d_m`) from implementation details (`interp1d_impl_s`), avoiding recompilation
  cascades across callers when internal numerical routines change.
- **Dynamic Memory Management (Chapter 08)**: Encapsulated allocatable state managed via
  type-bound constructor (`init`), evaluator (`eval`), and destructor (`destroy`) procedures.
- **Robust Unit Testing (Chapter 69)**: Assertion-based test suite validating interpolation
  accuracy, monotonicity verification, and boundary conditions.
- **Modern Packaging (Chapter 70)**: An `fpm.toml` package manifest defining library, include,
  and test configurations.
- **C Interoperability (Chapters 27 & 59)**: A standardized, versioned `bind(c)` entry point
  (`interp1d_linear`) and companion C header `include/interp1d.h` compiled and verified with
  a native C driver.
- **Python Integration (Chapter 56)**: Shared library (`libinterp1d.so`) called directly from
  Python via `ctypes`.

`build.sh` automatically compiles the Fortran module hierarchy, runs the test suite, links the
shared library, builds and runs the C caller, and executes the Python validation script.

## Examples

| Directory | Topic |
|---|---|
| [01_capstone_library/](01_capstone_library/) | 1-D linear interpolation library with modules, submodules, tests, C API, and Python interop |
