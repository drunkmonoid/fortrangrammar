! -----------------------------------------------------------------------------
! 03_ieee_classes_values.f90 - NaN, infinities, signed zero, subnormals
!
! Run:  scripts/run.sh 25-numeric-ieee/03_ieee_classes_values.f90
! -----------------------------------------------------------------------------
!
! use, intrinsic :: ieee_arithmetic
!
!   ieee_value(x, class)       a value of the class, kind of x:
!       ieee_quiet_nan, ieee_signaling_nan, ieee_positive_inf,
!       ieee_negative_inf, ieee_positive_zero, ieee_negative_zero,
!       ieee_positive_normal, ..._denormal (= subnormal)
!   ieee_class(x)              which class x belongs to
!   ieee_is_nan(x), ieee_is_finite(x), ieee_is_normal(x),
!   ieee_is_negative(x), ieee_signbit(x) (F2018), ieee_unordered(x, y)
!   ieee_copy_sign(x, y)       |x| with the sign of y
!   ieee_support_nan(x), ieee_support_inf(x), ieee_support_datatype(x), ...
!
! Facts: NaN /= NaN (so x /= x detects NaN, but use ieee_is_nan);
! -0.0 == 0.0 but has a different sign bit; 1/0 is +Inf.
! Creating these values with arithmetic raises IEEE flags (04_...);
! ieee_value does not.

program ieee_classes_values
  use, intrinsic :: ieee_arithmetic
  use, intrinsic :: iso_fortran_env, only: dp => real64
  implicit none (type, external)

  real(dp) :: nan, inf, neg_zero, sub

  nan = ieee_value(nan, ieee_quiet_nan)
  inf = ieee_value(inf, ieee_positive_inf)
  neg_zero = ieee_value(neg_zero, ieee_negative_zero)
  sub = tiny(1.0_dp) / 1024                     ! below tiny: subnormal

  print '(a, l1)', 'ieee_support_datatype : ', ieee_support_datatype(nan)
  print '(a, g0)', 'nan                   = ', nan
  print '(a, l1, 1x, l1)', 'nan == nan, nan /= nan: ', nan == nan, nan /= nan
  print '(a, l1)', 'ieee_is_nan(nan)      : ', ieee_is_nan(nan)
  print '(a, g0, 1x, g0)', 'inf, -inf             = ', inf, -inf
  print '(a, l1)', 'ieee_is_finite(inf)   : ', ieee_is_finite(inf)
  print '(a, l1, 1x, l1)', '-0 == 0, signbit(-0)  : ', neg_zero == 0, ieee_signbit(neg_zero)
  print '(a, g0)', '1 / -0                = ', 1 / neg_zero
  print '(a, es12.4e3)', 'subnormal             = ', sub
  print '(a, l1, 1x, l1)', 'is_normal(sub), > 0   : ', ieee_is_normal(sub), sub > 0
  print '(a, l1)', 'class(sub)==denormal  : ', ieee_class(sub) == ieee_positive_denormal
  print '(a, g0)', 'copy_sign(3, -1)      = ', ieee_copy_sign(3.0_dp, -1.0_dp)
  print '(a, l1)', 'unordered(nan, 1)     : ', ieee_unordered(nan, 1.0_dp)

end program ieee_classes_values

! Output:
! ieee_support_datatype : T
! nan                   = NaN
! nan == nan, nan /= nan: F T
! ieee_is_nan(nan)      : T
! inf, -inf             = Inf -Inf
! ieee_is_finite(inf)   : F
! -0 == 0, signbit(-0)  : T T
! 1 / -0                = -Inf
! subnormal             =  2.1729E-311
! is_normal(sub), > 0   : F T
! class(sub)==denormal  : T
! copy_sign(3, -1)      = -3.0000000000000000
! unordered(nan, 1)     : T
