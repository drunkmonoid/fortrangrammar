! -----------------------------------------------------------------------------
! 03_complex.f90 - the COMPLEX type
!
! Run:  scripts/run.sh 03-intrinsic-types/03_complex.f90
! -----------------------------------------------------------------------------
!
! COMPLEX is a pair of reals (real part, imaginary part) of the same kind.
! Its kind values are exactly the real kinds: complex(real64) holds two
! real(real64) values.
!
! Literal:   (1.0, 2.0)        both parts must be literal constants
!            (1.0_dp, -2.0_dp)
! Built from variables: cmplx(x, y, kind=dp)   - pass KIND, or the result is
!                                                 default complex (single)!
!
! Part designators (F2008):  z%re  z%im  - readable AND assignable.
! Intrinsics: real(z), aimag(z), conjg(z), abs(z) (modulus), atan2(aimag(z),
! real(z)) for the argument; sqrt, exp, log, sin, ... accept complex.

program complex_type
  use, intrinsic :: iso_fortran_env, only: dp => real64
  implicit none (type, external)

  complex :: z1
  complex(dp) :: z2, z3, w
  real(dp) :: x, y

  z1 = (3.0, 4.0)
  print '(a, 2(1x, f0.3))', 'z1 =', z1
  print '(a, f0.3)', '|z1| = ', abs(z1)

  x = 1.0_dp
  y = -2.0_dp
  z2 = cmplx(x, y, kind=dp)      ! without kind=dp the parts would be single
  z3 = (0.0_dp, 1.0_dp)          ! i

  print '(a, 2(1x, f0.3))', 'z2      =', z2
  print '(a, 2(1x, f0.3))', 'z2 * i  =', z2 * z3
  print '(a, 2(1x, f0.3))', 'conjg   =', conjg(z2)
  print '(a, f0.3, 1x, f0.3)', 'real, aimag = ', real(z2), aimag(z2)
  print '(a, f0.3, 1x, f0.3)', '%re, %im    = ', z2%re, z2%im

  ! Part designators are variables: assign one part.
  z2%im = 10.0_dp
  print '(a, 2(1x, f0.3))', 'after z2%im = 10:', z2

  ! The square root of -1 is fine in complex arithmetic.
  w = sqrt((-1.0_dp, 0.0_dp))
  print '(a, 2(1x, f0.3))', 'sqrt(-1) =', w

  ! Euler: exp(i*pi) = -1
  w = exp(z3 * acos(-1.0_dp))
  print '(a, 2(1x, f0.3))', 'exp(i pi) =', w

  print '(a, i0)', 'kind(z2) = ', kind(z2)

end program complex_type

! Output:
! z1 = 3.000 4.000
! |z1| = 5.000
! z2      = 1.000 -2.000
! z2 * i  = 2.000 1.000
! conjg   = 1.000 2.000
! real, aimag = 1.000 -2.000
! %re, %im    = 1.000 -2.000
! after z2%im = 10: 1.000 10.000
! sqrt(-1) = .000 1.000
! exp(i pi) = -1.000 .000
! kind(z2) = 8
