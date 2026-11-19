# 117 — Fortran 2008

Compiled with `-std=f2008`. This revision adds submodules, `do concurrent`,
`block`, `contiguous`, `newunit`, the `g0` edit descriptor,
`execute_command_line`, and coarrays. The coarray file also passes
`-fcoarray=single`, so it runs as one image.

`select rank` is Fortran 2018. `04_select_rank.f90` is `@build fail`.

`do concurrent` here has no `reduce` clause. That clause is later.

## Examples

| File | Topic |
|---|---|
| [01_language.f90](01_language.f90) | `block`, `do concurrent`, `contiguous`, `newunit`, `g0` |
| [02_submodule.f90](02_submodule.f90) | A module procedure in a submodule |
| [03_coarray.f90](03_coarray.f90) | One image |
| [04_select_rank.f90](04_select_rank.f90) | `select rank`, rejected by `-std=f2008` |
