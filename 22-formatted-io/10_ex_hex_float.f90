! @build skip F2018 EX edit descriptor is not implemented in gfortran 15
! -----------------------------------------------------------------------------
! 10_ex_hex_float.f90 - EX: hexadecimal floating point (F2018)
!
! Run:  needs a compiler with the EX edit descriptor
! -----------------------------------------------------------------------------
!
!   EXw.d      hexadecimal significand and binary exponent: 0X1.8P+1 (= 3.0)
!   EXw.dEe    with e exponent digits
!   EX0.0      minimal width, exact representation
!
! Hex-float output is EXACT (no decimal rounding), so writing and re-reading
! a value with EX0.0 restores the identical bits - like C's printf("%a").
! On input, EX accepts the same notation (and so do F/E/G since F2018).

program ex_hex_float
  implicit none (type, external)

  real :: x
  character(len=40) :: text

  print '(ex0.0)', 3.0
  print '(ex0.0)', 0.1
  write (text, '(ex0.0)') 0.1
  read (text, '(ex40.0)') x
  print '(a, l1)', 'round trip exact: ', x == 0.1

end program ex_hex_float
