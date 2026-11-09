# 63 — `do concurrent` Performance

A loop the compiler is allowed to parallelise, and the checksum it must
still produce. Timings stay out of the output: they change with the
machine and with `-ftree-parallelize-loops`. gfortran may ignore that
flag and run the loop serially. The checksum does not care.

## Example

| File | Topic |
|---|---|
| [01_checksum.f90](01_checksum.f90) | A filling loop, then `reduce(+:)` |

Writing the reduction by hand (`s = s + a(i)` with no `reduce`) tells
the compiler the iterations are not independent. If it parallelises
that loop anyway, the sum is a race. The file uses `reduce` and
describes the mistaken form in a comment.
