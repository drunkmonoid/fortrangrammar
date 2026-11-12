! MPI patterns: communicator splitting, derived datatypes, and non-blocking 1-D halo exchange.
!
! Deadlock note:
! A naive halo exchange using blocking MPI_Send to exchange boundaries with a neighbour
! can deadlock if both ranks attempt to send simultaneously and messages exceed the
! eager limit (causing MPI_Send to block waiting for MPI_Recv).
! To prevent deadlocks, either use MPI_Sendrecv or post non-blocking operations (MPI_Irecv
! and MPI_Isend) before synchronising with MPI_Waitall.

program mpi_patterns
  use, intrinsic :: iso_fortran_env, only: real64, output_unit, error_unit
  use mpi_f08
  implicit none (type, external)

  type :: particle_t
    integer :: id
    real(real64) :: x
    real(real64) :: y
  end type particle_t

  type(MPI_Comm) :: subcomm
  type(MPI_Datatype) :: particle_mpi_type
  type(MPI_Request) :: reqs(4)
  type(MPI_Status) :: statuses(4)

  integer :: rank, size, subrank, subsize
  integer :: left, right, color
  integer, parameter :: n = 4
  real(real64) :: grid(0:n+1)
  real(real64) :: local_sum, total_sum
  integer :: i

  ! Derived datatype setup variables
  type(particle_t) :: dummy_p
  type(MPI_Datatype) :: types(3)
  integer :: blocklengths(3)
  integer(MPI_ADDRESS_KIND) :: displacements(3), base_addr, addr

  call MPI_Init()
  call MPI_Comm_rank(MPI_COMM_WORLD, rank)
  call MPI_Comm_size(MPI_COMM_WORLD, size)

  ! 1. Split communicator into odd and even ranks
  color = mod(rank, 2)
  call MPI_Comm_split(MPI_COMM_WORLD, color, rank, subcomm)
  call MPI_Comm_rank(subcomm, subrank)
  call MPI_Comm_size(subcomm, subsize)

  ! 2. Build derived MPI datatype for particle_t struct
  types = [MPI_INTEGER, MPI_DOUBLE_PRECISION, MPI_DOUBLE_PRECISION]
  blocklengths = [1, 1, 1]
  call MPI_Get_address(dummy_p, base_addr)
  call MPI_Get_address(dummy_p%id, addr)
  displacements(1) = addr - base_addr
  call MPI_Get_address(dummy_p%x, addr)
  displacements(2) = addr - base_addr
  call MPI_Get_address(dummy_p%y, addr)
  displacements(3) = addr - base_addr

  call MPI_Type_create_struct(3, blocklengths, displacements, types, particle_mpi_type)
  call MPI_Type_commit(particle_mpi_type)

  ! 3. 1-D periodic halo exchange across MPI_COMM_WORLD
  ! Compute periodic left and right neighbours
  left = mod(rank - 1 + size, size)
  right = mod(rank + 1, size)

  ! Initialise interior grid cells with rank-dependent values
  grid(0) = 0.0_real64
  grid(n+1) = 0.0_real64
  do i = 1, n
    grid(i) = real(rank * 10 + i, kind=real64)
  end do

  ! Post non-blocking receives first
  call MPI_Irecv(grid(0), 1, MPI_DOUBLE_PRECISION, left, 100, MPI_COMM_WORLD, reqs(1))
  call MPI_Irecv(grid(n+1), 1, MPI_DOUBLE_PRECISION, right, 101, MPI_COMM_WORLD, reqs(2))

  ! Post non-blocking sends
  call MPI_Isend(grid(1), 1, MPI_DOUBLE_PRECISION, left, 101, MPI_COMM_WORLD, reqs(3))
  call MPI_Isend(grid(n), 1, MPI_DOUBLE_PRECISION, right, 100, MPI_COMM_WORLD, reqs(4))

  ! Wait for all communications to complete
  call MPI_Waitall(4, reqs, statuses)

  ! Verify halo integrity and calculate checksum
  local_sum = sum(grid(0:n+1))
  call MPI_Reduce(local_sum, total_sum, 1, MPI_DOUBLE_PRECISION, MPI_SUM, 0, MPI_COMM_WORLD)

  if (rank == 0) then
    write(output_unit, '(a,i0)') 'MPI halo exchange complete, ranks: ', size
    write(output_unit, '(a,f8.1)') 'Checksum: ', total_sum
  end if

  call MPI_Type_free(particle_mpi_type)
  call MPI_Comm_free(subcomm)
  call MPI_Finalize()
end program mpi_patterns
