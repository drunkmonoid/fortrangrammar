# 66 — MPI-IO

Standard serial file I/O causes a severe bottleneck when hundreds or thousands of
distributed MPI ranks attempt to read or write disk files independently.

MPI-IO provides high-performance parallel access to shared files through:
- **Collective file operations (`_all`)**: Permitting the underlying parallel file system
  (such as Lustre or GPFS) to coordinate data aggregation, stripe alignment, and two-phase I/O.
- **Explicit offset writing (`MPI_File_write_at_all`)**: Directing each rank to write its
  local partition into the shared file at a calculated byte displacement (`MPI_OFFSET_KIND`).
- **Collective reading (`MPI_File_read_at_all`)**: Enabling ranks to read contiguous or strided
  file regions into distributed arrays without rank 0 serialisation bottlenecks.

`build.sh` compiles with `mpifort`, runs across multiple ranks, verifies data integrity,
and cleans up output binary files upon exit. Exits with code 77 if MPI is not installed.

## Examples

| Directory | Topic |
|---|---|
| [01_parallel_io/](01_parallel_io/) | Collective parallel array writing and reading with MPI-IO |
