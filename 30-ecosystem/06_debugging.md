# Debugging and Profiling

## Compiler run-time checks (gfortran)

| Flag | Catches |
|---|---|
| `-fcheck=all` | out-of-bounds, unallocated/undefined pointers, recursion, do-loop, array temporaries ([06_runtime_checks.f90](06_runtime_checks.f90)) |
| `-g -fbacktrace` | source lines in error backtraces |
| `-ffpe-trap=invalid,zero,overflow` | first NaN/Inf-producing operation (SIGFPE) |
| `-finit-real=snan`, `-finit-integer=-99999`, `-finit-local-zero` | use of uninitialised variables |
| `-Wall -Wextra -Wimplicit-interface -Wconversion` | suspicious code at compile time |
| `-fsanitize=address` | heap/stack overflows, use-after-free, leaks |
| `-fsanitize=undefined` | undefined behaviour (e.g. integer overflow) |

Use the checks during development and testing; release builds drop them
for speed.

### Running this repository under the sanitizers

```sh
ASAN_OPTIONS=detect_leaks=0:allocator_may_return_null=1 \
FFLAGS="-std=f2023 -g -fcheck=all -fsanitize=address,undefined -ftrampoline-impl=heap" \
  scripts/check_all.sh
```

- `detect_leaks=0`: allocatables of the main program are never
  deallocated (they are implicitly saved), and gfortran keeps them in the
  `MAIN__` stack frame, so LeakSanitizer reports them at exit. libgfortran
  also keeps a `newlocale` allocation. Neither is a real leak; check leaks
  inside procedures with a dedicated test instead.
- `allocator_may_return_null=1`: let impossible allocations fail through
  `stat=` (chapter 24) instead of aborting inside ASan.
- `-ftrampoline-impl=heap` (GCC 14+): internal procedures passed as
  arguments (and gfortran's own `reduce` implementation) use stack
  trampolines, which crash under ASan without any diagnostic.

## gdb

```sh
gfortran -g -O0 prog.f90 -o prog
gdb ./prog
(gdb) break prog.f90:42        # or: break mymodule::myroutine
(gdb) run
(gdb) bt                       # backtrace
(gdb) print a(2:5)             # array sections work
(gdb) print obj%component
(gdb) ptype obj                # show a derived type
(gdb) info locals
(gdb) watch total              # stop when total changes
```

Module procedures are named `module::procedure` (gfortran mangles them as
`__module_MOD_procedure`).

## valgrind

```sh
valgrind --leak-check=full ./prog     # memory errors, leaks of pointers
```

## Profiling

```sh
gfortran -pg -O2 prog.f90 -o prog && ./prog && gprof ./prog gmon.out | less
perf record -g ./prog && perf report        # sampling profiler, no rebuild
```

For timing inside the code use `system_clock` (chapter 24).
