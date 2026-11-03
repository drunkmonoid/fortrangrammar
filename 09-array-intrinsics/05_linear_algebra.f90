! -----------------------------------------------------------------------------
! 05_linear_algebra.f90 - matmul, dot_product, norm2
!
! Run:  scripts/run.sh 09-array-intrinsics/05_linear_algebra.f90
! -----------------------------------------------------------------------------
!
!   matmul(a, b)        matrix product. Shapes allowed:
!                         (n,k) x (k,m) -> (n,m)
!                         (n,k) x (k)   -> (n)        matrix * vector
!                         (k)   x (k,m) -> (m)        vector * matrix
!                       Works for numeric and LOGICAL (and/or) arrays.
!   dot_product(a, b)   sum(a * b) for real/integer;
!                       sum(conjg(a) * b) for COMPLEX (first argument
!                       conjugated); any(a .and. b) for logical.
!   norm2(x [, dim])    Euclidean norm, computed without overflow (F2008).
!
! matmul is fine for moderate sizes; for large matrices call an optimised
! BLAS (dgemm). gfortran can do this automatically with -fexternal-blas.

program linear_algebra
  use, intrinsic :: iso_fortran_env, only: dp => real64
  implicit none (type, external)

  real(dp) :: a(2, 3), b(3, 2), c(2, 2), x(3), y(2)
  complex(dp) :: u(2), w(2)
  real(dp) :: big(2)
  integer :: i

  a = reshape([1, 4, 2, 5, 3, 6], shape(a))       ! [1 2 3; 4 5 6]
  b = transpose(a)
  x = [1.0_dp, 0.0_dp, -1.0_dp]

  c = matmul(a, b)
  print '(a)', 'matmul(a, transpose(a)):'
  do i = 1, 2
    print '(2f8.1)', c(i, :)
  end do

  y = matmul(a, x)
  print '(a, *(1x, f0.1))', 'matmul(a, x)    =', y
  print '(a, *(1x, f0.1))', 'matmul(y, a)    =', matmul(y, a)

  print '(a, f0.1)', 'dot_product(x, x) = ', dot_product(x, x)
  print '(a, f0.4)', 'norm2(x)          = ', norm2(x)
  print '(a, *(1x, f0.4))', 'norm2(a, dim=1)   =', norm2(a, dim=1)

  ! Complex: the first argument is conjugated.
  u = [(0.0_dp, 1.0_dp), (1.0_dp, 0.0_dp)]
  w = u
  print '(a, 2(1x, f0.1))', 'dot_product(u, u) =', dot_product(u, w)

  ! norm2 avoids overflow where sqrt(sum(x**2)) would not.
  big = [1.0e200_dp, 1.0e200_dp]
  ! es12.3e3: three exponent digits are needed for 1e+200 (chapter 22).
  print '(a, es12.3e3)', 'norm2(big)        = ', norm2(big)
  print '(a, es12.3e3)', 'sqrt(sum(big**2)) = ', sqrt(sum(big**2))

end program linear_algebra

! Output:
! matmul(a, transpose(a)):
!     14.0    32.0
!     32.0    77.0
! matmul(a, x)    = -2.0 -2.0
! matmul(y, a)    = -10.0 -14.0 -18.0
! dot_product(x, x) = 2.0
! norm2(x)          = 1.4142
! norm2(a, dim=1)   = 4.1231 5.3852 6.7082
! dot_product(u, u) = 2.0 .0
! norm2(big)        =   1.414E+200
! sqrt(sum(big**2)) =     Infinity
