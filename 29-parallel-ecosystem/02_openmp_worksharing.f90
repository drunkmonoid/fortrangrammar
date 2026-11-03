! @flags -fopenmp
! -----------------------------------------------------------------------------
! 02_openmp_worksharing.f90 - parallel loops, reductions, schedules, simd
!
! Run:  scripts/run.sh 29-parallel-ecosystem/02_openmp_worksharing.f90
! -----------------------------------------------------------------------------
!
!   !$omp parallel do [clauses]        split loop iterations over threads
!   reduction(op: var)                 private partial results combined at
!                                      the end: + * max min .and. .or. iand...
!   schedule(static[,chunk] | dynamic[,chunk] | guided | auto | runtime)
!   collapse(n)                        merge n nested loops into one space
!   !$omp simd                         vectorise a loop
!   !$omp parallel do simd             both
!   !$omp workshare                    parallelise array syntax / where /
!                                      forall statements (Fortran-only)
!
! The loop index of a parallel do is automatically private.

program openmp_worksharing
  use, intrinsic :: iso_fortran_env, only: dp => real64
  implicit none (type, external)

  integer, parameter :: n = 1000000, nt = 4
  real(dp), allocatable :: x(:), y(:)
  real(dp) :: total, biggest
  real(dp) :: grid(200, 300)
  integer :: i, j

  allocate (x(n), y(n))

  !$omp parallel do num_threads(nt) schedule(static) default(none) shared(x)
  do i = 1, n
    x(i) = 1.0_dp / i
  end do
  !$omp end parallel do

  total = 0
  biggest = -huge(biggest)
  !$omp parallel do num_threads(nt) reduction(+: total) reduction(max: biggest)
  do i = 1, n
    total = total + x(i)
    biggest = max(biggest, x(i))
  end do
  print '(a, f0.6, a, f0.1)', 'harmonic sum H(1e6) = ', total, ', max = ', biggest

  !$omp parallel do num_threads(nt) collapse(2) schedule(dynamic, 16)
  do j = 1, size(grid, 2)
    do i = 1, size(grid, 1)
      grid(i, j) = real(i + j, dp)
    end do
  end do
  print '(a, f0.1)', 'collapsed grid sum = ', sum(grid)

  !$omp simd
  do i = 1, n
    y(i) = 2 * x(i) + 1
  end do
  print '(a, f0.4)', 'simd y(2) = ', y(2)

  !$omp parallel num_threads(nt)
  !$omp workshare
    y = sqrt(x)
  !$omp end workshare
  !$omp end parallel
  print '(a, f0.4)', 'workshare sqrt(x(4)) = ', y(4)

end program openmp_worksharing

! Output:
! harmonic sum H(1e6) = 14.392727, max = 1.0
! collapsed grid sum = 15060000.0
! simd y(2) = 2.0000
! workshare sqrt(x(4)) = .5000
