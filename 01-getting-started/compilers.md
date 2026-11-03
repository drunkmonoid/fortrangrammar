# Compilers, Flags and File Extensions

## Compilers

| Compiler | Command | Notes |
|---|---|---|
| GNU Fortran | `gfortran` | Free, part of GCC. Used for every example here. |
| Intel Fortran (LLVM-based) | `ifx` | Free (oneAPI). Successor of the retired `ifort`. Strong F2018 support. |
| LLVM Flang | `flang` | Free, part of LLVM (formerly `flang-new`). Rapidly maturing. |
| LFortran | `lfortran` | Free, interactive/REPL capable. Still in development. |
| NVIDIA HPC SDK | `nvfortran` | Free. GPU offload via OpenACC, OpenMP and `do concurrent`. |
| AMD AOCC | `flang` | Free. LLVM Flang based, tuned for AMD CPUs. |
| HPE/Cray CCE | `ftn` | On Cray systems. Very complete coarray support. |
| NAG Fortran | `nagfor` | Commercial. Known for strict standard checking. |
| IBM Open XL Fortran | `xlf2008` and friends | Commercial, POWER and AIX. |

Feature support differs between compilers; chapter 30 has a support matrix.

## gfortran flags worth knowing

| Purpose | Flags |
|---|---|
| Standard conformance | `-std=f2023` (also `f2018`, `f2008`, `gnu`, `legacy`), `-pedantic` |
| Warnings | `-Wall -Wextra`, `-Wimplicit-interface`, `-Wimplicit-procedure`, `-Wconversion-extra`, `-Wunused-parameter` |
| Runtime checks | `-fcheck=all` (bounds, pointers, recursion, do-loop, mem, array temporaries) |
| Debugging | `-g`, `-fbacktrace`, `-ffpe-trap=invalid,zero,overflow`, `-finit-real=snan`, `-finit-integer=-99999` |
| Sanitizers | `-fsanitize=address,undefined` |
| Optimization | `-O0` … `-O3`, `-Ofast`, `-march=native`, `-flto` |
| Modules | `-J dir` (where to write `.mod`), `-I dir` (where to look for them) |
| Implicit typing | `-fimplicit-none` (as if every unit had `implicit none`) |
| Parallelism | `-fopenmp`, `-fopenacc`, `-fcoarray=single` / `-fcoarray=lib` |
| Preprocessor | `-cpp` (forced), `-nocpp`, `-D NAME=value` |
| Default kinds | `-fdefault-real-8`, `-fdefault-integer-8` (avoid: use kind parameters) |

A good development line:

```sh
gfortran -std=f2023 -Wall -Wextra -pedantic -fcheck=all -g -fbacktrace \
         -ffpe-trap=invalid,zero,overflow -finit-real=snan
```

A good release line:

```sh
gfortran -O3 -march=native -flto
```

## Rough equivalents on other compilers

| Purpose | gfortran | ifx | flang |
|---|---|---|---|
| Standard warnings | `-std=f2023 -pedantic` | `-stand f23` | `-pedantic` |
| Runtime checks | `-fcheck=all` | `-check all` | (limited) |
| Backtrace | `-fbacktrace` | `-traceback` | — |
| All warnings | `-Wall -Wextra` | `-warn all` | `-Wall` |
| Module output dir | `-J dir` | `-module dir` | `-module-dir dir` |
| OpenMP | `-fopenmp` | `-qopenmp` | `-fopenmp` |

Check each compiler's manual for the version you use; flag names change.

## File extensions

| Extension | Meaning |
|---|---|
| `.f90`, `.f95`, `.f03`, `.f08`, `.f18` | Free source form. Use `.f90` for everything. The number is **not** the language version. |
| `.F90` (uppercase) | Free form, passed through the C preprocessor first |
| `.f`, `.for`, `.ftn` | Fixed source form (legacy, not used here) |
| `.F`, `.FOR` | Fixed form + preprocessor |
| `.mod` | Compiled module interface (compiler-specific, not portable) |
| `.smod` | Compiled submodule interface (gfortran) |
| `.inc`, `.fi` | Files pulled in with `include` (conventional names only) |
