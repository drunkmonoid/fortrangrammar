! -----------------------------------------------------------------------------
! 02_real_manipulation.f90 - looking inside floating-point numbers
!
! Run:  scripts/run.sh 25-numeric-ieee/02_real_manipulation.f90
! -----------------------------------------------------------------------------
!
!   exponent(x)          e such that x = fraction(x) * 2**e
!   fraction(x)          the significand, in [0.5, 1)
!   set_exponent(x, i)   fraction(x) * 2**i
!   scale(x, i)          x * 2**i, exactly (no rounding unless out of range)
!   spacing(x)           distance to the next number of larger magnitude
!                        (an "ULP", unit in the last place)
!   nearest(x, s)        the next representable number toward sign(s)
!   rrspacing(x)         1 / (relative spacing) = |x| / spacing(x)
!
! These make "how close is close?" questions precise: compare numbers in
! ULPs, choose finite-difference steps, write tolerances that scale.

program real_manipulation
  use, intrinsic :: iso_fortran_env, only: dp => real64
  implicit none (type, external)

  real(dp) :: x

  x = 10.0_dp
  print '(a, i0)', 'exponent(10)      = ', exponent(x)
  print '(a, f0.4)', 'fraction(10)      = ', fraction(x)
  print '(a, f0.4)', 'set_exponent(10,1)= ', set_exponent(x, 1)
  print '(a, f0.1)', 'scale(10, 3)      = ', scale(x, 3)
  print '(a, es12.5)', 'spacing(10)       = ', spacing(x)
  print '(a, es12.5)', 'spacing(1e10)     = ', spacing(1.0e10_dp)
  print '(a, es23.16)', 'nearest(1, +1)    = ', nearest(1.0_dp, 1.0_dp)
  print '(a, es23.16)', 'nearest(1, -1)    = ', nearest(1.0_dp, -1.0_dp)
  print '(a, es12.5)', 'rrspacing(10)     = ', rrspacing(x)
  print '(a, l1)', 'spacing(1) == epsilon: ', spacing(1.0_dp) == epsilon(1.0_dp)

  ! Distance in ULPs between two nearby values.
  block
    real(dp) :: a, b
    a = 0.1_dp * 3
    b = 0.3_dp
    print '(a, f0.1)', '0.1*3 vs 0.3, ULPs apart: ', abs(a - b) / spacing(b)
  end block

end program real_manipulation

! Output:
! exponent(10)      = 4
! fraction(10)      = .6250
! set_exponent(10,1)= 1.2500
! scale(10, 3)      = 80.0
! spacing(10)       =  1.77636E-15
! spacing(1e10)     =  1.90735E-06
! nearest(1, +1)    =  1.0000000000000002E+00
! nearest(1, -1)    =  9.9999999999999989E-01
! rrspacing(10)     =  5.62950E+15
! spacing(1) == epsilon: T
! 0.1*3 vs 0.3, ULPs apart: 1.0
