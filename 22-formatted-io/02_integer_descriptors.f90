! -----------------------------------------------------------------------------
! 02_integer_descriptors.f90 - I, B, O, Z
!
! Run:  scripts/run.sh 22-formatted-io/02_integer_descriptors.f90
! -----------------------------------------------------------------------------
!
!   Iw       decimal, right-justified in w columns
!   Iw.m     at least m digits (leading zeros)
!   I0       minimal width (F95) - the most useful one
!   Bw[.m]   binary         Ow[.m]  octal         Zw[.m]  hexadecimal
!   B0, O0, Z0   minimal width
!
! If the value does not fit in w columns, the field is filled with
! ASTERISKS - output never silently drops digits.
! Signs: negative values get '-'; '+' only with SP (06_sign_...).
! B/O/Z show the bit pattern; for negatives that is two's complement.

program integer_descriptors
  implicit none (type, external)

  integer :: n

  n = 42
  print '("[", i5, "]")', n
  print '("[", i5.4, "]")', n
  print '("[", i0, "]")', n
  print '("[", i0, "]")', -n
  print '("[", i2, "]")', 1234                 ! does not fit: **
  print '("[", b0, "] [", b8.8, "]")', n, n
  print '("[", o0, "] [", z0, "] [", z4.4, "]")', n, n, n
  print '("[", z0, "]")', -1                   ! two's complement bits
  print '("[", 3i4, "]")', 1, 22, 333

end program integer_descriptors

! Output:
! [   42]
! [ 0042]
! [42]
! [-42]
! [**]
! [101010] [00101010]
! [52] [2A] [002A]
! [FFFFFFFF]
! [   1  22 333]
