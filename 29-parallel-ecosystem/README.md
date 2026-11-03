# 29 — Parallel Ecosystem: OpenMP, OpenACC, MPI

The three external parallel standards used with Fortran in practice.
OpenMP and OpenACC are directives (comments with sentinels); MPI is a
library.

## Examples

| File | Topic |
|---|---|
| [01_openmp_parallel_regions.f90](01_openmp_parallel_regions.f90) | `parallel`, data scoping, `single`, `atomic`, `omp_lib` |
| [02_openmp_worksharing.f90](02_openmp_worksharing.f90) | `parallel do`, `reduction`, `schedule`, `collapse`, `simd`, `workshare` |
| [03_openmp_tasks.f90](03_openmp_tasks.f90) | `task`, `taskwait`, `sections` |
| [04_openmp_target.f90](04_openmp_target.f90) | GPU offload: `target teams distribute parallel do`, `map` |
| [05_conditional_compilation.f90](05_conditional_compilation.f90) | `!$` sentinel lines, `_OPENMP` |
| [06_openacc.f90](06_openacc.f90) | `!$acc parallel loop`, `data`, `reduction` |
| [07_mpi_basics.f90](07_mpi_basics.f90) | `mpi_f08`: init, rank/size, send/recv ring ⚠ needs MPI |
| [08_mpi_collectives.f90](08_mpi_collectives.f90) | `MPI_Scatter`, `MPI_Allreduce`, non-blocking exchange ⚠ needs MPI |
| [09_hybrid_mpi_openmp.f90](09_hybrid_mpi_openmp.f90) | `MPI_Init_thread` + OpenMP ⚠ needs MPI |

The MPI files are skipped by `check_all.sh` because no MPI library is
installed here. With Open MPI or MPICH:

```sh
mpifort 29-parallel-ecosystem/07_mpi_basics.f90 -o mpi_basics
mpirun -n 4 ./mpi_basics
```

## Choosing a model

| Model | Memory | Granularity | Where |
|---|---|---|---|
| `do concurrent` (ch. 28) | shared (or offloaded) | loops | standard Fortran, portable |
| coarrays (ch. 28) | distributed (PGAS) | images | standard Fortran |
| OpenMP | shared + offload | loops, tasks, regions | everywhere (`-fopenmp`) |
| OpenACC | accelerators | loops, data regions | nvfortran, gfortran, flang |
| MPI | distributed | processes | every cluster |

## Compiler flags

| Compiler | OpenMP | OpenACC | MPI wrapper |
|---|---|---|---|
| gfortran | `-fopenmp` | `-fopenacc` | `mpifort` / `mpif90` |
| ifx | `-qopenmp` (`-fopenmp-targets=spir64` offload) | — | `mpiifx` |
| nvfortran | `-mp` (`-mp=gpu`) | `-acc` | `mpifort` |
| flang | `-fopenmp` | `-fopenacc` | `mpifort` |

## Key points

- `default(none)` in OpenMP and `default(none)` in `do concurrent` catch
  forgotten private variables.
- Reductions (`reduction(+: s)`) beat critical sections and atomics.
- `!$ ` lines keep code compilable without OpenMP.
- Prefer `use mpi_f08` over `use mpi` / `mpif.h`: it is type-checked.
- Non-blocking MPI buffers must not be touched before `MPI_Wait`; mark
  them `asynchronous`.
- Hybrid codes: request `MPI_THREAD_FUNNELED` (or higher) and check it.
