# 116 — Fortran 2003

Compiled with `-std=f2003`. This revision adds type extension, `class`,
type-bound procedures, `iso_c_binding`, the IEEE modules, stream access,
`move_alloc`, allocatable components, and deferred-length characters.

`block` is Fortran 2008. `03_block.f90` is `@build fail` under
`-std=f2003`.

## Examples

| File | Topic |
|---|---|
| [01_types.f90](01_types.f90) | Extension, a deferred-length name, `move_alloc` |
| [02_ieee_stream.f90](02_ieee_stream.f90) | IEEE, `c_loc`, and a stream file |
| [03_block.f90](03_block.f90) | `block`, rejected by `-std=f2003` |
