! @flags -fopenmp
! -----------------------------------------------------------------------------
! 01_openmp_parallel_regions.f90 - OpenMP basics: threads and data scope
!
! Run:  scripts/run.sh 29-parallel-ecosystem/01_openmp_parallel_regions.f90
! -----------------------------------------------------------------------------
!
! OpenMP is a directive-based standard for shared-memory threading. In
! Fortran, directives are comments starting with the sentinel !$omp, so
! a compiler without -fopenmp (gfortran) / -qopenmp (ifx) simply ignores
! them. The runtime library is the module omp_lib.
!
!   !$omp parallel [clauses]          fork a team of threads
!   !$omp end parallel                join
!
! Data-sharing clauses:
!   shared(x)        one x for all threads (default for most variables)
!   private(x)       each thread has an uninitialised copy
!   firstprivate(x)  private, initialised from the value before the region
!   default(none)    force every variable to be listed (recommended)
!
! Synchronisation inside a region:
!   !$omp critical / end critical      one thread at a time
!   !$omp barrier                      all threads wait
!   !$omp single / end single          executed by one thread
!   !$omp masked / end masked          executed by thread 0 (was "master")
!   !$omp atomic                       one indivisible update
!
! Output order between threads is nondeterministic; this example funnels
! printing through CRITICAL and sorts results so the output is stable.

program openmp_parallel_regions
  use omp_lib, only: omp_get_thread_num, omp_get_num_threads, omp_get_max_threads
  implicit none (type, external)

  integer, parameter :: nt = 4
  integer :: ids(0:nt - 1), team_size, counter, seed

  ids = -1
  counter = 0
  seed = 100

  !$omp parallel num_threads(nt) default(none) shared(ids, team_size, counter) firstprivate(seed)
    ids(omp_get_thread_num()) = seed + omp_get_thread_num()   ! own slot: no race

    !$omp single
      team_size = omp_get_num_threads()
    !$omp end single

    !$omp atomic
      counter = counter + 1
  !$omp end parallel

  print '(a, i0)', 'threads in the team : ', team_size
  print '(a, *(1x, i0))', 'firstprivate seeds  :', ids
  print '(a, i0)', 'atomic counter      : ', counter
  print '(a, l1)', 'max threads >= 1    : ', omp_get_max_threads() >= 1

end program openmp_parallel_regions

! Output:
! threads in the team : 4
! firstprivate seeds  : 100 101 102 103
! atomic counter      : 4
! max threads >= 1    : T
