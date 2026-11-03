# 30 — Ecosystem and Tooling

Everything around the language: building, packaging, testing, documenting,
debugging, libraries — plus a feature-support summary for the whole
tutorial.

## Contents

| File / directory | Topic |
|---|---|
| [01_fpm_project/](01_fpm_project/) | fpm layout (`fpm.toml`, `src/`, `app/`, `test/`) |
| [02_cmake_project/](02_cmake_project/) | CMake library + executable + ctest |
| [03_make_project/](03_make_project/) | Makefile with module dependencies |
| [04_unit_testing.f90](04_unit_testing.f90) | Unit-test pattern; test-drive, pFUnit, veggies |
| [05_ford_documented.f90](05_ford_documented.f90) / [05_ford.md](05_ford.md) | FORD documentation comments and setup |
| [06_runtime_checks.f90](06_runtime_checks.f90) / [06_debugging.md](06_debugging.md) | `-fcheck`, sanitizers, gdb, valgrind, profilers |
| [07_stdlib_example.f90](07_stdlib_example.f90) | Fortran stdlib tour ⚠ needs stdlib |
| [08_tooling.md](08_tooling.md) | fortls, fprettify, fortitude, LFortran, CI |
| [09_feature_support.md](09_feature_support.md) | Which F2018/F2023 features gfortran 15 accepts |

The full list of examples in all chapters is in [../INDEX.md](../INDEX.md).

## Build-system comparison

| | fpm | CMake | Make |
|---|---|---|---|
| Module dependency order | automatic | automatic | by hand (or makedepf90) |
| Dependencies / packages | built in (git, registry) | `FetchContent`, `find_package` | manual |
| Tests | `fpm test` | `ctest` | manual target |
| Mixed C/C++ | yes (simple) | excellent | manual |
| Best for | Fortran-first projects | large / mixed projects, HPC | small projects, learning |

## Key points

- New Fortran projects: start with fpm; switch to CMake when you need
  complex mixed-language builds.
- Always run tests with run-time checks enabled.
- Document public APIs with FORD comments (`!>` / `!!`).
- Feature support varies — test on every compiler you target.
