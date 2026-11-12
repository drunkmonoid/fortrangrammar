# 88 — Derived-Type Dump

Fortran does not provide runtime field-name reflection. To inspect or log
nested derived types cleanly, modules commonly supply a `dump` subroutine
(or defined derived-type I/O, Chapter 20) that formats components into
`name = value` lines inside a character buffer.

This chapter also respects binary floating-point exactness (Chapter 40):
real values are formatted with `f0.1` only when they are exact dyadic
fractions (`0.0`, `0.5`, `1.0`), avoiding cross-platform rounding differences.

## Examples

| File | Topic |
|---|---|
| [01_dump.f90](01_dump.f90) | Dump a nested derived type into a `name = value` buffer |
