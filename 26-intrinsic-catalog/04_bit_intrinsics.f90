! -----------------------------------------------------------------------------
! 04_bit_intrinsics.f90 - bit manipulation
!
! Run:  scripts/run.sh 26-intrinsic-catalog/04_bit_intrinsics.f90
! -----------------------------------------------------------------------------
!
! Integers are treated as sequences of bit_size(i) bits, numbered from 0
! (least significant). All are elemental.
!
!   iand ior ieor not                 bitwise logic
!   ibset(i, pos) ibclr(i, pos)       set / clear one bit
!   btest(i, pos)                     test one bit (logical)
!   ibits(i, pos, len)                extract a field
!   call mvbits(from, frompos, len, to, topos)   copy a field (subroutine)
!   ishft(i, shift)                   logical shift (+left, -right)
!   ishftc(i, shift [, size])         circular shift
!   shiftl shiftr shifta              left / logical right / ARITHMETIC right
!   dshiftl(i, j, s) dshiftr(i, j, s) double-width shifts (F2008)
!   maskl(n) maskr(n)                 n ones at the left / right
!   merge_bits(i, j, mask)            bits of i where mask is 1, else j
!   popcnt(i) poppar(i)               number of 1 bits / its parity
!   leadz(i) trailz(i)                leading / trailing zero bits
!   bge bgt ble blt                   UNSIGNED comparison of bit patterns
!   bit_size(i)                       number of bits in the model
!
! Negative values use two's complement in practice, but the model treats
! the bits as unsigned for bge/bgt/ble/blt.

program bit_intrinsics
  implicit none (type, external)

  integer :: a, b, field

  a = int(b'1100')
  b = int(b'1010')

  print '(a, b4.4)', 'iand  = ', iand(a, b)
  print '(a, b4.4)', 'ior   = ', ior(a, b)
  print '(a, b4.4)', 'ieor  = ', ieor(a, b)
  print '(a, b32.32)', 'not(a)= ', not(a)
  print '(a, b5.5)', 'ibset(a, 0) = ', ibset(a, 0)
  print '(a, b4.4)', 'ibclr(a, 3) = ', ibclr(a, 3)
  print '(a, l1, 1x, l1)', 'btest(a, 2), btest(a, 0) = ', btest(a, 2), btest(a, 0)
  print '(a, b2.2)', 'ibits(a, 2, 2) = ', ibits(a, 2, 2)

  field = 0
  call mvbits(a, 2, 2, field, 4)
  print '(a, b8.8)', 'mvbits -> ', field

  print '(a, i0, 1x, i0)', 'ishft(1, 4), ishft(16, -2) = ', ishft(1, 4), ishft(16, -2)
  print '(a, b8.8)', 'ishftc(b''00000011'', -1, 8) = ', ishftc(3, -1, 8)
  print '(a, i0, 1x, i0)', 'shiftr(-16, 2), shifta(-16, 2) = ', shiftr(-16, 2), shifta(-16, 2)
  print '(a, b32.32)', 'maskl(4)    = ', maskl(4)
  print '(a, b8.8)', 'maskr(3)    = ', maskr(3)
  print '(a, b4.4)', 'merge_bits(a, b, b''0011'') = ', merge_bits(a, b, int(b'0011'))
  print '(a, i0, 1x, i0)', 'popcnt(255), poppar(7) = ', popcnt(255), poppar(7)
  print '(a, i0, 1x, i0)', 'leadz(1), trailz(8)    = ', leadz(1), trailz(8)
  print '(a, l1, 1x, l1)', '-1 > 1 signed / bgt(-1, 1) unsigned: ', -1 > 1, bgt(-1, 1)
  print '(a, i0)', 'bit_size(0) = ', bit_size(0)

end program bit_intrinsics

! Output:
! iand  = 1000
! ior   = 1110
! ieor  = 0110
! not(a)= 11111111111111111111111111110011
! ibset(a, 0) = 01101
! ibclr(a, 3) = 0100
! btest(a, 2), btest(a, 0) = T F
! ibits(a, 2, 2) = 11
! mvbits -> 00110000
! ishft(1, 4), ishft(16, -2) = 16 4
! ishftc(b'00000011', -1, 8) = 10000001
! shiftr(-16, 2), shifta(-16, 2) = 1073741820 -4
! maskl(4)    = 11110000000000000000000000000000
! maskr(3)    = 00000111
! merge_bits(a, b, b'0011') = 1000
! popcnt(255), poppar(7) = 8 1
! leadz(1), trailz(8)    = 31 3
! -1 > 1 signed / bgt(-1, 1) unsigned: F T
! bit_size(0) = 32
