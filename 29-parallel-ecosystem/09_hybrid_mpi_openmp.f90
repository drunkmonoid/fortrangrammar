! @build skip needs an MPI library (e.g. Open MPI or MPICH) with the mpi_f08 module
! -----------------------------------------------------------------------------
! 09_hybrid_mpi_openmp.f90 - MPI between nodes, OpenMP within a node
!
! Build/run:  mpifort -fopenmp 09_hybrid_mpi_openmp.f90 -o hybrid
!             OMP_NUM_THREADS=4 mpirun -n 2 ./hybrid
! -----------------------------------------------------------------------------
!
! Initialise MPI with MPI_Init_thread and request the threading level you
! need; check what the library provides:
!   MPI_THREAD_SINGLE      only one thread exists
!   MPI_THREAD_FUNNELED    threads exist, only the main thread calls MPI
!   MPI_THREAD_SERIALIZED  any thread calls MPI, one at a time
!   MPI_THREAD_MULTIPLE    any thread, any time
! FUNNELED covers the common pattern: OpenMP compute loops, MPI calls
! outside parallel regions (or inside !$omp masked).

program hybrid_mpi_openmp
  use mpi_f08
  use omp_lib, only: omp_get_max_threads
  implicit none (type, external)

  integer :: provided, rank, i
  real :: local, total
  integer, parameter :: n = 1000000

  call MPI_Init_thread(MPI_THREAD_FUNNELED, provided)
  if (provided < MPI_THREAD_FUNNELED) error stop 'MPI lacks FUNNELED support'
  call MPI_Comm_rank(MPI_COMM_WORLD, rank)

  local = 0
  !$omp parallel do reduction(+: local)
  do i = rank * n + 1, (rank + 1) * n
    local = local + 1.0 / i
  end do

  call MPI_Reduce(local, total, 1, MPI_REAL, MPI_SUM, 0, MPI_COMM_WORLD)
  if (rank == 0) print '(a, i0, a, f0.4)', 'threads per rank ', omp_get_max_threads(), &
      ', partial harmonic sum ', total

  call MPI_Finalize()

end program hybrid_mpi_openmp
