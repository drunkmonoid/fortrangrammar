! @build skip needs an MPI library (e.g. Open MPI or MPICH) with the mpi_f08 module
! -----------------------------------------------------------------------------
! 07_mpi_basics.f90 - MPI with the modern mpi_f08 bindings
!
! Build/run:  mpifort 07_mpi_basics.f90 -o mpi_basics && mpirun -n 4 ./mpi_basics
! -----------------------------------------------------------------------------
!
! MPI (Message Passing Interface) is a library standard for distributed
! memory: separate processes ("ranks") exchange messages. It is the most
! widely used parallel model in HPC Fortran.
!
! Always use `use mpi_f08` (MPI-3): communicators and datatypes are
! derived types (type(MPI_Comm), type(MPI_Datatype)), arguments are
! type-checked, ierror is optional. The older `use mpi` and `include
! 'mpif.h'` use bare integers and are not type-safe.
!
! Core calls:
!   MPI_Init / MPI_Finalize
!   MPI_Comm_rank(comm, rank) / MPI_Comm_size(comm, size)
!   MPI_Send(buf, count, type, dest, tag, comm)
!   MPI_Recv(buf, count, type, source, tag, comm, status)
!   MPI_Sendrecv, MPI_Isend / MPI_Irecv + MPI_Wait (non-blocking)

program mpi_basics
  use mpi_f08
  implicit none (type, external)

  integer :: rank, nranks, token, left, right
  type(MPI_Status) :: status

  call MPI_Init()
  call MPI_Comm_rank(MPI_COMM_WORLD, rank)
  call MPI_Comm_size(MPI_COMM_WORLD, nranks)

  print '(a, i0, a, i0)', 'hello from rank ', rank, ' of ', nranks

  ! Pass a token around a ring.
  right = mod(rank + 1, nranks)
  left = mod(rank - 1 + nranks, nranks)
  if (rank == 0) then
    token = 1
    call MPI_Send(token, 1, MPI_INTEGER, right, 0, MPI_COMM_WORLD)
    call MPI_Recv(token, 1, MPI_INTEGER, left, 0, MPI_COMM_WORLD, status)
    print '(a, i0)', 'token came back as ', token
  else
    call MPI_Recv(token, 1, MPI_INTEGER, left, 0, MPI_COMM_WORLD, status)
    token = token + 1
    call MPI_Send(token, 1, MPI_INTEGER, right, 0, MPI_COMM_WORLD)
  end if

  call MPI_Finalize()

end program mpi_basics
