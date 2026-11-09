# 73 — Profiling

| File | Topic |
|---|---|
| [01_temporary.f90](01_temporary.f90) | `b = a + a` beside an element loop |

Two ways to compute `2*a`. The whole-array statement may allocate a
temporary for the right-hand side. The loop writes each element and
does not. Both checksums are 20; the time they take is not part of the
output.

Rebuild the whole-array program with `-Warray-temporaries` to see
whether this compiler inserted a temporary. A profile is
`gfortran -pg` and then `gprof`, or `perf stat` on the same binary
(chapter 30, `06_debugging.md`).
