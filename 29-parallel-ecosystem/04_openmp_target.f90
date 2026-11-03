! @flags -fopenmp
! -----------------------------------------------------------------------------
! 04_openmp_target.f90 - offloading to an accelerator (OpenMP 4.5+)
!
! Run:  scripts/run.sh 29-parallel-ecosystem/04_openmp_target.f90
! -----------------------------------------------------------------------------
!
!   !$omp target teams distribute parallel do map(to: a) map(from: b)
!   !$omp target data map(tofrom: x) ... !$omp end target data
!   !$omp target update to(x) / from(x)
!   !$omp declare target
!
! map(to/from/tofrom/alloc: ...) moves data between host and device.
! Without an accelerator (or a compiler built without offload support)
! target regions run on the host, so this program works everywhere;
! omp_get_num_devices() and omp_is_initial_device() tell you where you are.
! gfortran offloads to NVIDIA (nvptx) / AMD (gcn) when built with them;
! nvfortran, ifx and amdflang have their own offload toolchains.

program openmp_target
  use omp_lib, only: omp_get_num_devices
  use, intrinsic :: iso_fortran_env, only: dp => real64
  implicit none (type, external)

  integer, parameter :: n = 100000
  real(dp), allocatable :: a(:), b(:)
  real(dp) :: total
  integer :: i

  allocate (a(n), b(n))
  a = [(real(i, dp), i = 1, n)]

  !$omp target teams distribute parallel do map(to: a) map(from: b)
  do i = 1, n
    b(i) = 2 * a(i)
  end do

  total = 0
  !$omp target teams distribute parallel do map(to: b) map(tofrom: total) reduction(+: total)
  do i = 1, n
    total = total + b(i)
  end do

  print '(a, l1)', 'devices available >= 0 : ', omp_get_num_devices() >= 0
  print '(a, f0.1, a, f0.1)', 'sum of 2*i            = ', total, ', exact ', real(n, dp) * (n + 1)

end program openmp_target

! Output:
! devices available >= 0 : T
! sum of 2*i            = 10000100000.0, exact 10000100000.0
