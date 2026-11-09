! @run no
! -----------------------------------------------------------------------------
! 01_wrong.f90 - an off-by-one and a real used before it is defined
!
! Compile only: scripts/check_all.sh 72-debugging-numerics
! -----------------------------------------------------------------------------
!
! n is one past size(a). Under -fcheck=all the store into a(i) stops
! with the runtime error from 30-ecosystem/06_runtime_checks.f90 and
! exit status 2. x is read with no value; -finit-real=snan turns that
! into a floating-point invalid operation if the bounds check is off
! and -ffpe-trap=invalid is on.
!
!   gdb -ex run -ex bt -- args ./a.out
!
! 02_corrected.f90 is the same program with both mistakes removed.
! This file is not executed.

program wrong
  implicit none (type, external)

  integer :: a(5), i, n
  real :: x

  n = 6
  do i = 1, n
    a(i) = i
  end do
  print '(a, f0.1)', 'x = ', x

end program wrong
