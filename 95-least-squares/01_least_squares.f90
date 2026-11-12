! -----------------------------------------------------------------------------
! 01_least_squares.f90 - Ordinary least squares via normal equations
!
! Run:  scripts/run.sh 95-least-squares/01_least_squares.f90
! -----------------------------------------------------------------------------
!
! Fits y = a + b * x to points (0, 1), (1, 3), (2, 5) by forming the 2x2
! normal equations:
!   [ n      sum(x)    ] [ a ]   [ sum(y)   ]
!   [ sum(x) sum(x**2) ] [ b ] = [ sum(x*y) ]
!
! Solved directly by Gaussian elimination without linking LAPACK (phase 43).

program least_squares
  use, intrinsic :: iso_fortran_env, only: real64, output_unit
  implicit none (type, external)

  integer, parameter :: n = 3
  real(real64) :: x(n), y(n), mat(2, 2), rhs(2), factor, a, b

  x = [0.0_real64, 1.0_real64, 2.0_real64]
  y = [1.0_real64, 3.0_real64, 5.0_real64]

  mat(1, 1) = real(n, kind=real64)
  mat(1, 2) = sum(x)
  mat(2, 1) = mat(1, 2)
  mat(2, 2) = sum(x * x)

  rhs(1) = sum(y)
  rhs(2) = sum(x * y)

  ! Gaussian elimination on the 2x2 normal system
  factor = mat(2, 1) / mat(1, 1)
  mat(2, 2) = mat(2, 2) - factor * mat(1, 2)
  rhs(2) = rhs(2) - factor * rhs(1)

  b = rhs(2) / mat(2, 2)
  a = (rhs(1) - mat(1, 2) * b) / mat(1, 1)

  write(output_unit, '(a,1x,i0)') 'a =', nint(a)
  write(output_unit, '(a,1x,i0)') 'b =', nint(b)

end program least_squares

! Output:
! a = 1
! b = 2
