! -----------------------------------------------------------------------------
! 02_real.f90 - the REAL type and floating-point literals
!
! Run:  scripts/run.sh 03-intrinsic-types/02_real.f90
! -----------------------------------------------------------------------------
!
! REAL is approximate (floating-point). Kinds from iso_fortran_env:
!   real32   IEEE single  (~7 decimal digits)
!   real64   IEEE double  (~15 decimal digits)
!   real128  quad         (~33 digits; software-emulated on x86)
!   real16   half (F2023; negative = unavailable, as in gfortran 15)
! gfortran on x86 also has kind=10 (80-bit extended) - see 06_kind_arrays.f90.
!
! Literal syntax:
!   1.0   1.   .5   1e3   1.5e-3   2.0E+10      default real
!   1.0_real64   1.5e-3_dp                        kind suffix
!   1.0d0                                         double precision (old style)
!
! THE classic bug: a literal without a suffix is DEFAULT real (single),
! even when assigned to a double variable. The conversion happens after the
! value was already rounded to single precision. Always suffix literals.
!
! `double precision` is still a valid type name meaning "a real kind with
! more precision than default real". Prefer real(real64) or a named kind.

program real_type
  use, intrinsic :: iso_fortran_env, only: real32, real64, real128
  implicit none (type, external)

  integer, parameter :: dp = real64
  real :: single
  real(real32) :: also_single
  real(dp) :: double, wrong
  real(real128) :: quad
  double precision :: old_style
  ! selected_real_kind(p, r): at least p decimal digits and exponent range r.
  integer, parameter :: wp = selected_real_kind(p=12, r=100)
  real(wp) :: working

  single = 0.1
  also_single = 0.1_real32
  double = 0.1_dp
  wrong = 0.1               ! single-precision 0.1, widened afterwards!
  quad = 0.1_real128
  old_style = 0.1d0
  working = 0.1_wp

  print '(a, g0)', 'single     : ', single
  print '(a, g0)', 'double     : ', double
  print '(a, g0)', 'wrong      : ', wrong
  print '(a, g0)', 'quad       : ', quad
  print '(a, g0)', 'old style  : ', old_style
  print '(a, i0, a, g0)', 'wp (kind ', wp, '): ', working
  print '(a, l1)', 'also_single == single? ', also_single == single

  print '(a)', ''
  print '(a)', 'kind     digits  precision  range   epsilon'
  print '(i4, 2x, i6, 2x, i9, 2x, i5, 3x, es10.3)', &
      real32, digits(single), precision(single), range(single), epsilon(single)
  print '(i4, 2x, i6, 2x, i9, 2x, i5, 3x, es10.3)', &
      real64, digits(double), precision(double), range(double), epsilon(double)
  print '(i4, 2x, i6, 2x, i9, 2x, i5, 3x, es10.3)', &
      real128, digits(quad), precision(quad), range(quad), epsilon(quad)

  ! Exponent letters: E for any kind, D for double precision only.
  print '(a, g0)', '1.5e3   = ', 1.5e3
  print '(a, g0)', '1.5d3   = ', 1.5d3
  print '(a, g0)', '1.5e3_dp= ', 1.5e3_dp

end program real_type

! Output:
! single     : 0.100000001
! double     : 0.10000000000000001
! wrong      : 0.10000000149011612
! quad       : 0.100000000000000000000000000000000005
! old style  : 0.10000000000000001
! wp (kind 8): 0.10000000000000001
! also_single == single? T
!
! kind     digits  precision  range   epsilon
!    4      24          6     37    1.192E-07
!    8      53         15    307    2.220E-16
!   16     113         33   4931    1.926E-34
! 1.5e3   = 1500.00000
! 1.5d3   = 1500.0000000000000
! 1.5e3_dp= 1500.0000000000000
