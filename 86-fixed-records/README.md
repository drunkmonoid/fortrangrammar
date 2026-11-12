# 86 — Fixed-Width Records

Fixed-width columnar records store each field at a fixed byte/character offset
rather than separating columns with commas (as in Phase 50's CSV parser). This
layout is common in legacy scientific tables, Fortran card-image formats, and
fixed-column log files.

This chapter demonstrates:
- Writing formatted records `(i4,a8,i6)` into a temporary `status='scratch'` file
- Rewinding and reading each record line-by-line
- Extracting fields by substring positions (`line(1:4)`, `line(5:12)`, `line(13:18)`)
  and trimming padding blanks with `trim(adjustl(...))`

## Examples

| File | Topic |
|---|---|
| [01_fixed_records.f90](01_fixed_records.f90) | Write and read fixed-width records via a scratch file |
