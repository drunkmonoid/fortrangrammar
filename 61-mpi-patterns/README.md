# 61 — MPI Patterns

This chapter extends the MPI introduction in [29-parallel-ecosystem/](../29-parallel-ecosystem/)
with production patterns using the modern `mpi_f08` standard interface:

1. **Communicator splitting (`MPI_Comm_split`)**: Subdividing communicators to create independent sub-groups of ranks (e.g. colour-based splitting).
2. **Derived struct datatypes (`MPI_Type_create_struct`)**: Translating user-defined Fortran derived types into registered MPI datatypes using portable byte displacements computed via `MPI_Get_address`.
3. **Non-blocking 1-D halo exchange (`MPI_Irecv`, `MPI_Isend`, `MPI_Waitall`)**: Overlapping point-to-point boundary exchanges across distributed domains to eliminate blocking serialization and buffer-overflow deadlocks.

## Deadlock Prevention

In a bidirectional boundary exchange, calling blocking `MPI_Send` on all ranks before `MPI_Recv` can easily deadlock if messages exceed the implementation's internal eager buffer threshold. Posting non-blocking receives (`MPI_Irecv`) followed by non-blocking sends (`MPI_Isend`) and then waiting on the request handles with `MPI_Waitall` guarantees deadlock-free progress across all domain ranks.

`build.sh` uses `mpifort` to compile against `mpi_f08` and runs under `mpirun` or `mpiexec`, exiting with code 77 if MPI is not installed.

## Examples

| Directory | Topic |
|---|---|
| [01_halo_exchange/](01_halo_exchange/) | Split communicators, derived datatypes, and non-blocking halo exchange |
