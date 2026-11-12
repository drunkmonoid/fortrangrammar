# 69 — Test-Drive

[test-drive](https://github.com/fortran-lang/test-drive) is a lightweight, pure-Fortran
testing framework developed by the `fortran-lang` community. It provides structured unit
testing with custom assertions, failure context collection, and integration with `fpm test`.

This chapter demonstrates:
- A multi-target `fpm` package configured with `test-drive` in `[dev-dependencies]`
- Managing separate test programs for discrete library components
- A dependency-free fallback test runner module that collects failure counts and issues
  proper process exit codes for automated testing pipelines

`build.sh` invokes `fpm test` when `fpm` and network/dependencies are available, exiting
with code 77 otherwise.

## Examples

| File / Directory | Topic |
|---|---|
| [01_fallback_assert.f90](01_fallback_assert.f90) | Pure Fortran dependency-free assert test runner with collected results |
| [02_test_drive_pkg/](02_test_drive_pkg/) | Multi-test fpm package integrating the test-drive framework |
