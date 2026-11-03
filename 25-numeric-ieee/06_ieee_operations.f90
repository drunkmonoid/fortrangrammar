! -----------------------------------------------------------------------------
! 06_ieee_operations.f90 - IEEE operations (F2003 / F2018)
!
! Run:  scripts/run.sh 25-numeric-ieee/06_ieee_operations.f90
! -----------------------------------------------------------------------------
!
!   ieee_next_after(x, y)     next representable value from x toward y
!   ieee_rem(x, y)            IEEE remainder: x - y*n, n = nearest integer
!   ieee_logb(x)              unbiased exponent, as a real
!   ieee_scalb(x, i)          x * 2**i
!   ieee_fma(a, b, c)         a*b + c with ONE rounding (F2018)
!   ieee_max_num, ieee_min_num, ieee_max_num_mag, ieee_min_num_mag (F2018)
!                             max/min that IGNORE a quiet NaN operand
!   ieee_quiet_eq/_ne/_lt/_le/_gt/_ge, ieee_signaling_* (F2018)
!                             comparisons with explicit NaN signalling
!
! Not yet in gfortran 15: ieee_next_up/down, ieee_real, ieee_int (F2018),
! and the F2023 ieee_max/ieee_min/ieee_max_mag/ieee_min_mag (which
! propagate NaN, as IEEE 754-2019 maximum/minimum).

program ieee_operations
  use, intrinsic :: ieee_arithmetic
  use, intrinsic :: iso_fortran_env, only: dp => real64
  implicit none (type, external)

  real(dp) :: nan, a, b, c

  nan = ieee_value(nan, ieee_quiet_nan)

  print '(a, es24.17)', 'next_after(1, 2)   = ', ieee_next_after(1.0_dp, 2.0_dp)
  print '(a, f0.2)', 'ieee_rem(10, 3)    = ', ieee_rem(10.0_dp, 3.0_dp)
  print '(a, f0.2)', 'ieee_rem(11, 3)    = ', ieee_rem(11.0_dp, 3.0_dp)
  print '(a, f0.2, a, f0.2)', 'mod(11, 3)         = ', mod(11.0_dp, 3.0_dp), &
      '   (mod truncates, ieee_rem rounds)'
  print '(a, f0.1)', 'ieee_logb(1000)    = ', ieee_logb(1000.0_dp)
  print '(a, f0.1)', 'ieee_scalb(3, 4)   = ', ieee_scalb(3.0_dp, 4)

  ! FMA keeps the low bits that a separate multiply would round away.
  a = 1.0_dp + epsilon(a)
  b = 1.0_dp - epsilon(b)
  c = -1.0_dp
  print '(a, es12.4)', 'a*b + c (two roundings) = ', a * b + c
  print '(a, es12.4)', 'ieee_fma(a, b, c)       = ', ieee_fma(a, b, c)

  print '(a, f0.1)', 'ieee_max_num(nan, 2)    = ', ieee_max_num(nan, 2.0_dp)
  print '(a, g0)', 'max(nan, 2) (processor) = ', max(nan, 2.0_dp)
  print '(a, l1)', 'ieee_quiet_eq(nan, nan) : ', ieee_quiet_eq(nan, nan)

end program ieee_operations

! Output:
! next_after(1, 2)   =  1.00000000000000022E+00
! ieee_rem(10, 3)    = 1.00
! ieee_rem(11, 3)    = -1.00
! mod(11, 3)         = 2.00   (mod truncates, ieee_rem rounds)
! ieee_logb(1000)    = 9.0
! ieee_scalb(3, 4)   = 48.0
! a*b + c (two roundings) =   0.0000E+00
! ieee_fma(a, b, c)       =  -4.9304E-32
! ieee_max_num(nan, 2)    = 2.0
! max(nan, 2) (processor) = NaN
! ieee_quiet_eq(nan, nan) : F
