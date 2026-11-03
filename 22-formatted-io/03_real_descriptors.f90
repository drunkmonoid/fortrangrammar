! -----------------------------------------------------------------------------
! 03_real_descriptors.f90 - F, E, ES, EN, D, G for reals
!
! Run:  scripts/run.sh 22-formatted-io/03_real_descriptors.f90
! -----------------------------------------------------------------------------
!
!   Fw.d      fixed point, d decimals              F0.d  minimal width
!   Ew.d      exponential, 0.ddddE+xx               (mantissa < 1)
!   Ew.dEe    with e exponent digits
!   ESw.d     SCIENTIFIC: d.dddE+xx (1 <= mantissa < 10)
!   ENw.d     ENGINEERING: exponent a multiple of 3 (1 <= mantissa < 1000)
!   Dw.d      like E with a D exponent letter (legacy)
!   Gw.d      general: F if the magnitude suits d significant digits, else E
!   G0        processor-chosen "complete" representation
!   G0.d      G0 with d significant digits
!
! Width rules: w counts everything (sign, digits, point, exponent).
! A too-small w gives asterisks. With Ew.d and a 3-digit exponent the 'E'
! is DROPPED (1.0+100) unless you request Ee digits - use Ew.dE3 or ES.
! F0.d omits the leading zero of values below 1 in gfortran (.500); that is
! processor-dependent - the standard allows either.

program real_descriptors
  use, intrinsic :: iso_fortran_env, only: dp => real64
  implicit none (type, external)

  real(dp) :: x

  x = 1234.5678_dp
  print '(a, "[", f10.3, "]")', 'f10.3   ', x
  print '(a, "[", f0.2, "]")',  'f0.2    ', x
  print '(a, "[", e12.4, "]")', 'e12.4   ', x
  print '(a, "[", e12.4e3, "]")', 'e12.4e3 ', x
  print '(a, "[", es12.4, "]")', 'es12.4  ', x
  print '(a, "[", en12.4, "]")', 'en12.4  ', x
  print '(a, "[", d12.4, "]")', 'd12.4   ', x
  print '(a, "[", g12.4, "]")', 'g12.4   ', x
  print '(a, "[", g0, "]")', 'g0      ', x
  print '(a, "[", g0.4, "]")', 'g0.4    ', x
  print '(a, "[", f5.1, "]")', 'f5.1 too narrow ', x

  x = 1.0e-100_dp
  print '(a, "[", e12.4, "]")', 'e12.4 tiny  ', x
  print '(a, "[", es12.4e3, "]")', 'es12.4e3    ', x

  x = 0.5_dp
  print '(a, "[", f0.3, "]")', 'f0.3 of 0.5 ', x
  print '(a, "[", g12.4, "]")', 'g12.4 of 0.5', x

  ! Complex values take two real descriptors.
  print '(a, "(", f0.2, ", ", f0.2, ")")', 'complex     ', (1.5_dp, -2.0_dp)

end program real_descriptors

! Output:
! f10.3   [  1234.568]
! f0.2    [1234.57]
! e12.4   [  0.1235E+04]
! e12.4e3 [ 0.1235E+004]
! es12.4  [  1.2346E+03]
! en12.4  [  1.2346E+03]
! d12.4   [  0.1235D+04]
! g12.4   [   1235.    ]
! g0      [1234.5678000000000]
! g0.4    [1235.]
! f5.1 too narrow [*****]
! e12.4 tiny  [  0.1000E-99]
! es12.4e3    [ 1.0000E-100]
! f0.3 of 0.5 [.500]
! g12.4 of 0.5[  0.5000    ]
! complex     (1.50, -2.00)
