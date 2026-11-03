! -----------------------------------------------------------------------------
! 05_conditional_compilation.f90 - code that works with and without OpenMP
!
! Run:  scripts/run.sh 29-parallel-ecosystem/05_conditional_compilation.f90
!       FFLAGS="-std=f2023 -fopenmp" scripts/run.sh 29-parallel-ecosystem/05_conditional_compilation.f90
! -----------------------------------------------------------------------------
!
! Lines starting with the sentinel `!$ ` (followed by a blank) are
! compiled ONLY when OpenMP is enabled; otherwise they are comments. Use
! this for omp_lib calls so the same source builds serially:
!
!   !$ use omp_lib, only: omp_get_max_threads
!   !$ n = omp_get_max_threads()
!
! In preprocessed (.F90) files the macro _OPENMP (value yyyymm of the
! supported spec) can be tested with #ifdef instead.

program conditional_compilation
  !$ use omp_lib, only: omp_get_max_threads
  implicit none (type, external)

  integer :: threads

  threads = 1
  !$ threads = omp_get_max_threads()
  if (threads == 1) then
    print '(a)', 'running serially (or with one thread)'
  else
    print '(a)', 'running with OpenMP threads available'
  end if

end program conditional_compilation

! Output:
! running serially (or with one thread)
