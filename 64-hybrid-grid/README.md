# 64 — Hybrid Grid

On modern supercomputers and multi-socket NUMA systems, high-performance Fortran
applications frequently combine **distributed-memory MPI** across compute nodes
with **shared-memory OpenMP** within each node (the hybrid MPI+OpenMP programming model).

This chapter demonstrates a 2-D Jacobi stencil relaxation on an $N_x \times N_y$ grid:
- **MPI domain decomposition**: Global rows are partitioned across ranks, with adjacent
  ranks exchanging row halos via non-blocking `MPI_Irecv` / `MPI_Isend` / `MPI_Waitall`.
- **OpenMP thread worksharing**: Columns within each rank's local row block are updated
  in parallel across threads using `!$omp parallel do collapse(2)`.
- **Serial verification**: Rank 0 executes an identical pure serial algorithm, confirming
  that the distributed hybrid computation produces bitwise and floating-point identical results.

`build.sh` compiles with `mpifort -fopenmp` and executes under `mpirun` or single-rank fallback, exiting with code 77 if MPI is not installed.

## Examples

| Directory | Topic |
|---|---|
| [01_jacobi/](01_jacobi/) | 2-D Jacobi relaxation with MPI across rows and OpenMP across columns |
