# 52 — JSON

A reader and writer for a small subset: objects, arrays, strings, numbers,
`true`, `false`, and `null`. A value is a derived type with allocatable
components (chapters 16 and 20). Numbers are kept as text, so a round
trip does not have to decide a kind. Strings understand `\"` and `\\`.
There is no Unicode escape.

The second example calls json-fortran and exits 77 when that module is
not installed.

## Examples

| File | Topic |
|---|---|
| [01_subset.f90](01_subset.f90) | Parse a document and write it back |
| [02_json_fortran/](02_json_fortran/) | The same lookup with json-fortran |
