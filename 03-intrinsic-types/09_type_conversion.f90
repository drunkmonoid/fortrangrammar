! -----------------------------------------------------------------------------
! 09_type_conversion.f90 - converting between intrinsic types and kinds
!
! Run:  scripts/run.sh 03-intrinsic-types/09_type_conversion.f90
! -----------------------------------------------------------------------------
!
! Conversion intrinsics (all take an optional KIND= argument):
!
!   int(x)       truncate toward zero          int(-2.7)    = -2
!   nint(x)      round to nearest, half away   nint(-2.5)   = -3
!   floor(x)     round toward -infinity        floor(-2.7)  = -3
!   ceiling(x)   round toward +infinity        ceiling(-2.7)= -2
!   real(x)      to real; real(z) = real part
!   cmplx(x, y)  to complex
!   logical(l)   between logical kinds
!   char(i), ichar(c), achar(i), iachar(c)   character <-> code
!   transfer(x, mold)   reinterpret bits (chapter 26)
!
! Without KIND=, the result has DEFAULT kind: real(n) of an int64 n is a
! default (single) real, losing digits. Always pass kind= for non-default.
!
! Assignment converts implicitly: integer = real truncates, real = complex
! drops the imaginary part. -Wconversion (in -Wall) warns about these.

program type_conversion
  use, intrinsic :: iso_fortran_env, only: dp => real64, int64
  implicit none (type, external)

  real(dp) :: x
  integer(int64) :: big
  integer :: n

  x = -2.7_dp
  print '(a, 4(1x, i0))', 'int, nint, floor, ceiling of -2.7:', &
      int(x), nint(x), floor(x), ceiling(x)
  print '(a, 2(1x, i0))', 'nint(2.5), nint(-2.5):', nint(2.5_dp), nint(-2.5_dp)

  big = 123456789012_int64
  print '(a, g0)', 'real(big)          = ', real(big)          ! default real: digits lost
  print '(a, g0)', 'real(big, kind=dp) = ', real(big, kind=dp)

  ! int() of a value too big for the default integer is undefined behaviour;
  ! ask for a big enough kind.
  print '(a, i0)', 'int(1.0e12_dp, int64) = ', int(1.0e12_dp, kind=int64)

  ! Mixed-mode assignment truncates silently (with a warning).
  n = int(3.99_dp)
  print '(a, i0)', 'int(3.99) = ', n

  ! Character <-> integer codes.
  print '(a, i0, 1x, a)', "iachar('A'), achar(97): ", iachar('A'), achar(97)

end program type_conversion

! Output:
! int, nint, floor, ceiling of -2.7: -2 -3 -3 -2
! nint(2.5), nint(-2.5): 3 -3
! real(big)          = 0.123456791E+12
! real(big, kind=dp) = 123456789012.00000
! int(1.0e12_dp, int64) = 1000000000000
! int(3.99) = 3
! iachar('A'), achar(97): 65 a
