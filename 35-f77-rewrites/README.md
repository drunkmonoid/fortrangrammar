# 35 — Fortran 77 Rewrites

Three small programs written twice. `legacy.f` is fixed form and uses the
obsolescent spellings from chapters 31–33. `modern.f90` is the same
calculation with a module, an array intrinsic, or a block `do`. Each
`build.sh` compiles both and diffs their output.

## Examples

| Directory | Legacy | Modern |
|---|---|---|
| [01_mean/](01_mean/) | Labelled `do` and `data` | `sum` and `size` |
| [02_stencil/](02_stencil/) | Labelled `do` over a 3-point stencil | Block `do` |
| [03_state/](03_state/) | `common` plus `block data` | A module variable |

The diff is the test. The programs print the same lines, so a change to
either side that is not a real change of the result fails `build.sh`.
