! -----------------------------------------------------------------------------
! 06_sign_blank_round_decimal.f90 - mode-changing descriptors
!
! Run:  scripts/run.sh 22-formatted-io/06_sign_blank_round_decimal.f90
! -----------------------------------------------------------------------------
! These descriptors change a MODE for the rest of the format (or until
! changed again); several also exist as OPEN/WRITE specifiers (sign=,
! blank=, round=, decimal=):
!
!   SP / SS / S       plus sign shown / suppressed / processor default
!   BN / BZ           input: blanks in numeric fields ignored / read as 0
!   RU RD RZ RN       rounding: up, down, toward zero, nearest
!   RC RP             nearest with ties away from zero / processor-defined
!   DC / DP           decimal COMMA (1,5) / decimal POINT (1.5)
!   kP                scale factor: F output multiplied by 10**k; for E
!                     the mantissa is shifted (legacy, avoid)

program sign_blank_round_decimal
  implicit none (type, external)

  real :: x
  integer :: n
  character(len=4) :: field

  print '(sp, i0, 1x, f0.1, ss, 1x, i0)', 5, 2.5, 5

  field = '1 2 '
  read (field, '(bn, i4)') n
  print '(a, i0)', "bn read of '1 2 ' -> ", n
  read (field, '(bz, i4)') n
  print '(a, i0)', "bz read of '1 2 ' -> ", n

  x = 2.25
  print '(a, f4.1)', 'default rounding    : ', x
  print '(a, ru, f4.1, rd, f4.1, rz, f4.1, rn, f4.1)', 'ru rd rz rn on 2.25:', x, x, x, x
  print '(a, ru, f5.1, rd, f5.1, rz, f5.1, rc, f5.1)', 'ru rd rz rc on -2.25:', -x, -x, -x, -x

  print '(a, dc, f9.2, dp, f9.2)', 'dc, dp:', 1234.5, 1234.5

  print '(a, f8.3, 2p, f8.3)', 'scale factor 2p:', 1.5, 1.5

end program sign_blank_round_decimal

! Output:
! +5 +2.5 5
! bn read of '1 2 ' -> 12
! bz read of '1 2 ' -> 1020
! default rounding    :  2.2
! ru rd rz rn on 2.25: 2.3 2.2 2.2 2.2
! ru rd rz rc on -2.25: -2.2 -2.3 -2.2 -2.3
! dc, dp:  1234,50  1234.50
! scale factor 2p:   1.500 150.000
