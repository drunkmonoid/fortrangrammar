! -----------------------------------------------------------------------------
! 05_ieee_rounding.f90 - rounding modes
!
! Run:  scripts/run.sh 25-numeric-ieee/05_ieee_rounding.f90
! -----------------------------------------------------------------------------
!
!   ieee_get_rounding_mode(mode)      ieee_set_rounding_mode(mode)
!   modes: ieee_nearest (default), ieee_up, ieee_down, ieee_to_zero,
!          ieee_away (F2018, support optional), ieee_other
!   ieee_support_rounding(mode [, x])
!   ieee_rint(x)                      round to an integral value in the
!                                     current mode (the F2018 optional ROUND
!                                     argument is not in gfortran 15)
!
! Like flags, the rounding mode is restored when a procedure returns.
! Interval arithmetic computes the same sum rounding down and rounding up
! to bound the true value - shown below.
! Compile without aggressive optimisation (-O0 here) so the compiler does
! not evaluate the sums at compile time in the default mode.

program ieee_rounding
  use, intrinsic :: ieee_arithmetic
  use, intrinsic :: iso_fortran_env, only: dp => real64
  implicit none (type, external)

  type(ieee_round_type) :: saved
  real(dp) :: lo, hi
  real(dp), volatile :: third

  third = 1.0_dp
  call ieee_get_rounding_mode(saved)

  call ieee_set_rounding_mode(ieee_down)
  lo = third / 3
  call ieee_set_rounding_mode(ieee_up)
  hi = third / 3
  call ieee_set_rounding_mode(saved)

  print '(a, es24.17)', '1/3 rounded down: ', lo
  print '(a, es24.17)', '1/3 rounded up  : ', hi
  print '(a, l1)', 'hi - lo == spacing: ', hi - lo == spacing(lo)

  ! In the default mode ieee_rint rounds ties to EVEN, unlike nint/anint,
  ! which round ties away from zero.
  ! (Observed with gfortran 15: under ieee_up/ieee_down, ieee_rint(-2.5)
  ! returned -3/-2 instead of the IEEE results -2/-3, while division
  ! honoured the modes. Check directed-rounding results on your compiler.)
  print '(a, 4(1x, f4.1))', 'ieee_rint(0.5, 1.5, 2.5, 3.5):', &
      ieee_rint(0.5_dp), ieee_rint(1.5_dp), ieee_rint(2.5_dp), ieee_rint(3.5_dp)
  print '(a, 4(1x, f4.1))', 'anint    (0.5, 1.5, 2.5, 3.5):', &
      anint(0.5_dp), anint(1.5_dp), anint(2.5_dp), anint(3.5_dp)
  print '(a, l1)', 'ieee_away supported: ', ieee_support_rounding(ieee_away, lo)

end program ieee_rounding

! Output:
! 1/3 rounded down:  3.33333333333333315E-01
! 1/3 rounded up  :  3.33333333333333370E-01
! hi - lo == spacing: T
! ieee_rint(0.5, 1.5, 2.5, 3.5):  0.0  2.0  2.0  4.0
! anint    (0.5, 1.5, 2.5, 3.5):  1.0  2.0  3.0  4.0
! ieee_away supported: F
