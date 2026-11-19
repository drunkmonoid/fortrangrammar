! Exercise 25: a finite value and a quiet NaN.
program ex25
  use, intrinsic :: iso_fortran_env, only: real64
  use, intrinsic :: ieee_arithmetic, only: ieee_is_finite, ieee_quiet_nan, ieee_value
  implicit none (type, external)

  real(real64) :: ordinary, quiet

  ordinary = 1.0_real64
  quiet = ieee_value(ordinary, ieee_quiet_nan)
  print '(a, l1)', 'finite: ', ieee_is_finite(ordinary)
  print '(a, l1)', 'nan finite: ', ieee_is_finite(quiet)

end program ex25

! Output:
! finite: T
! nan finite: F
