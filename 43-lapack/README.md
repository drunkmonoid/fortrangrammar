# 43 — LAPACK

Three dense problems, each checked against a known answer. `build.sh`
links `-llapack -lblas` (or the `pkg-config` line) and exits 77 when
LAPACK is not installed.

`info = 0` means the call succeeded. A negative `info` names the
argument that was illegal, counting from 1. A positive `info` means the
factorisation or the iteration failed; the program stops with that
number rather than printing a vector that is not a solution.

Phase 95 solves a least-squares line with no library. This chapter is
the LAPACK path for the same idea.

## Examples

| File | Topic |
|---|---|
| [01_solve/](01_solve/) | `dgesv`, `dgels`, and `dsyev` |
