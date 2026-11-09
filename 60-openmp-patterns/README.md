# 60 — OpenMP Patterns

Worksharing beyond the introduction in chapter 29. The executed program
uses `collapse` and a reduction, so the printed sums do not depend on
the number of threads or on the schedule.

A race is a loop that writes a shared variable from several iterations
with no `reduction`, `atomic` or `critical`. The wrong loop is in the
comments of the example and is not compiled: running it would make the
output depend on the timing.

## Example

| File | Topic |
|---|---|
| [01_collapse_reduction.f90](01_collapse_reduction.f90) | `collapse(2)`, `reduction(+:)`, `simd` |

Compile with `-fopenmp`, which the file requests. The sums are 30 and 10
with one thread or with several.
