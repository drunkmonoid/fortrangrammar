! @flags -fopenacc
! -----------------------------------------------------------------------------
! 06_openacc.f90 - OpenACC directives
!
! Run:  scripts/run.sh 29-parallel-ecosystem/06_openacc.f90
! -----------------------------------------------------------------------------
!
! OpenACC is a directive standard aimed at accelerators (GPUs), driven
! mainly by NVIDIA (nvfortran) and supported by gfortran (-fopenacc) and
! LLVM Flang. Sentinel: !$acc. Module: openacc.
!
!   !$acc parallel loop [gang] [vector] [reduction(+:s)] [copyin(a)] [copyout(b)]
!   !$acc kernels ... !$acc end kernels          compiler finds parallelism
!   !$acc data copyin(a) copyout(b) ... !$acc end data
!   !$acc update host(x) / device(x)
!   !$acc routine seq                           device-callable procedure
!
! Data clauses: copy, copyin, copyout, create, present, deviceptr.
! Without an accelerator gfortran runs the regions on the host.

program openacc_demo
  use, intrinsic :: iso_fortran_env, only: dp => real64
  implicit none (type, external)

  integer, parameter :: n = 100000
  real(dp), allocatable :: x(:), y(:)
  real(dp) :: total
  integer :: i

  allocate (x(n), y(n))
  x = 1.0

  !$acc data copyin(x) copyout(y)
    !$acc parallel loop
    do i = 1, n
      y(i) = 3 * x(i) + i
    end do
  !$acc end data

  total = 0
  !$acc parallel loop reduction(+: total) copyin(y)
  do i = 1, n
    total = total + y(i)
  end do

  print '(a, es12.5)', 'sum(y) = ', total
  print '(a, es12.5)', 'exact  = ', 3.0_dp * n + real(n, dp) * (n + 1) / 2

end program openacc_demo

! Output:
! sum(y) =  5.00035E+09
! exact  =  5.00035E+09
