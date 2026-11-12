# 87 — Use Scanner

Build tools such as `fpm` and dependency generators determine module compilation order
by scanning Fortran source files for `use` statements.

This chapter demonstrates a lightweight line-oriented `use` scanner that:
- Ignores comment lines beginning with `!`
- Skips `use, intrinsic` module imports
- Handles optional `, non_intrinsic` and `::` syntax
- Extracts non-intrinsic module names cleanly

## Examples

| File | Topic |
|---|---|
| [01_use_scanner.f90](01_use_scanner.f90) | Scan a Fortran source sample and list external `use` module names |
