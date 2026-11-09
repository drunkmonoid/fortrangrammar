# 72 — Debugging a Wrong Answer

Two programs. The first compiles and is not run: it writes one past the
end of an array and reads a real that was never given a value. With the
default `-fcheck=all` the first of those stops the program at run time
(chapter 30). The second is the correction, and its output is checked.

The commands for the broken run are the ones in
[chapter 30](../30-ecosystem/06_debugging.md): `-fcheck=all`,
`-finit-real=snan`, and `gdb` with `bt` after the trap.

## Examples

| File | Topic |
|---|---|
| [01_wrong.f90](01_wrong.f90) | Off-by-one and an undefined real. `@run no` |
| [02_corrected.f90](02_corrected.f90) | The loop bound is `size`, and the real is set |
