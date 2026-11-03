! @build skip needs an MPI library (e.g. Open MPI or MPICH) with the mpi_f08 module
! -----------------------------------------------------------------------------
! 08_mpi_collectives.f90 - collectives and non-blocking communication
!
! Build/run:  mpifort 08_mpi_collectives.f90 -o coll && mpirun -n 4 ./coll
! -----------------------------------------------------------------------------
!
!   MPI_Bcast(buf, count, type, root, comm)
!   MPI_Reduce(send, recv, count, type, op, root, comm)     op: MPI_SUM ...
!   MPI_Allreduce(send, recv, count, type, op, comm)
!   MPI_Scatter / MPI_Gather / MPI_Allgather / MPI_Alltoall
!   MPI_Barrier(comm)
!   MPI_Isend / MPI_Irecv -> type(MPI_Request); MPI_Wait / MPI_Waitall
!
! Buffers in non-blocking calls must not be touched until the request
! completes; declare them ASYNCHRONOUS (F2018 interoperates with MPI-3 here).

program mpi_collectives
  use mpi_f08
  use, intrinsic :: iso_fortran_env, only: dp => real64
  implicit none (type, external)

  integer :: rank, nranks, i
  real(dp) :: local_sum, global_sum
  real(dp), allocatable :: chunk(:), full(:)
  real(dp), asynchronous :: halo_out, halo_in
  type(MPI_Request) :: requests(2)
  integer, parameter :: per_rank = 4

  call MPI_Init()
  call MPI_Comm_rank(MPI_COMM_WORLD, rank)
  call MPI_Comm_size(MPI_COMM_WORLD, nranks)

  ! Root builds the data, scatters equal chunks, everyone reduces.
  allocate (chunk(per_rank))
  if (rank == 0) then
    full = [(real(i, dp), i = 1, per_rank * nranks)]
  else
    allocate (full(0))
  end if
  call MPI_Scatter(full, per_rank, MPI_DOUBLE_PRECISION, chunk, per_rank, &
                   MPI_DOUBLE_PRECISION, 0, MPI_COMM_WORLD)
  local_sum = sum(chunk)
  call MPI_Allreduce(local_sum, global_sum, 1, MPI_DOUBLE_PRECISION, MPI_SUM, MPI_COMM_WORLD)
  if (rank == 0) print '(a, f0.1)', 'global sum = ', global_sum

  ! Non-blocking halo exchange with the right neighbour.
  halo_out = real(rank, dp)
  call MPI_Irecv(halo_in, 1, MPI_DOUBLE_PRECISION, mod(rank - 1 + nranks, nranks), 1, &
                 MPI_COMM_WORLD, requests(1))
  call MPI_Isend(halo_out, 1, MPI_DOUBLE_PRECISION, mod(rank + 1, nranks), 1, &
                 MPI_COMM_WORLD, requests(2))
  call MPI_Waitall(2, requests, MPI_STATUSES_IGNORE)
  print '(a, i0, a, f0.1)', 'rank ', rank, ' received halo ', halo_in

  call MPI_Finalize()

end program mpi_collectives
