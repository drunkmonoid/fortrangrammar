! -----------------------------------------------------------------------------
! 07_ieee_features.f90 - requesting IEEE features
!
! Run:  scripts/run.sh 25-numeric-ieee/07_ieee_features.f90
! -----------------------------------------------------------------------------
!
!   use, intrinsic :: ieee_features, only: ieee_datatype, ieee_inf, ...
!
! Accessing a named constant of ieee_features in a scoping unit REQUESTS
! that feature for that unit; the compiler may then generate slower but
! IEEE-conforming code there (or refuse to compile if impossible).
! Constants: ieee_datatype, ieee_denormal (subnormal), ieee_divide,
! ieee_halting, ieee_inexact_flag, ieee_inf, ieee_invalid_flag, ieee_nan,
! ieee_rounding, ieee_sqrt, ieee_subnormal (F2018), ieee_underflow_flag.
!
! On mainstream x86/ARM compilers everything is supported anyway, so the
! module mostly documents intent. The ieee_support_* inquiry functions
! answer the same questions at run time.

program ieee_features_demo
  use, intrinsic :: ieee_features, only: ieee_datatype, ieee_halting, ieee_subnormal
  use, intrinsic :: ieee_arithmetic, only: ieee_support_datatype, ieee_support_halting, &
                                           ieee_support_subnormal, ieee_support_sqrt, &
                                           ieee_support_standard, ieee_invalid
  implicit none (type, external)

  real :: x

  x = 1.0
  print '(a, l1)', 'ieee_support_datatype  : ', ieee_support_datatype(x)
  print '(a, l1)', 'ieee_support_standard  : ', ieee_support_standard(x)
  print '(a, l1)', 'ieee_support_subnormal : ', ieee_support_subnormal(x)
  print '(a, l1)', 'ieee_support_sqrt      : ', ieee_support_sqrt(x)
  print '(a, l1)', 'ieee_support_halting   : ', ieee_support_halting(ieee_invalid)

end program ieee_features_demo

! Output:
! ieee_support_datatype  : T
! ieee_support_standard  : T
! ieee_support_subnormal : T
! ieee_support_sqrt      : T
! ieee_support_halting   : T
