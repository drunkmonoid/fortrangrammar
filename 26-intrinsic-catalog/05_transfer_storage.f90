! -----------------------------------------------------------------------------
! 05_transfer_storage.f90 - TRANSFER and STORAGE_SIZE
!
! Run:  scripts/run.sh 26-intrinsic-catalog/05_transfer_storage.f90
! -----------------------------------------------------------------------------
!
!   transfer(source, mold [, size])
!       Reinterpret the BITS of source as the type of mold (no conversion).
!       Scalar mold -> scalar result; array mold -> rank-1 result sized to
!       hold all of source (or SIZE elements).
!   storage_size(a [, kind])       (F2008) size of one element in BITS
!   c_sizeof(x)                    (iso_c_binding) size in BYTES, for
!                                  interoperable entities
!
! transfer is the standard replacement for EQUIVALENCE tricks: inspecting
! float bit patterns, packing data into byte buffers, hashing.
! The result depends on the processor's representation (endianness, IEEE).

program transfer_storage
  use, intrinsic :: iso_fortran_env, only: int8, int32, int64, real32, real64
  use, intrinsic :: iso_c_binding, only: c_sizeof, c_double
  implicit none (type, external)

  real(real32) :: x
  integer(int32) :: bits
  integer(int8), allocatable :: bytes(:)
  character(len=4) :: text
  real(c_double) :: cd

  x = 1.0
  bits = transfer(x, bits)
  print '(a, z8.8)', 'bits of 1.0         = 0x', bits
  print '(a, f0.1)', 'back to real        = ', transfer(bits, x)

  ! Pull apart sign, exponent and mantissa.
  bits = transfer(-6.5_real32, bits)
  print '(a, i0, a, i0, a, z6.6)', 'sign ', ibits(bits, 31, 1), ', exponent ', &
      ibits(bits, 23, 8) - 127, ', mantissa 0x', ibits(bits, 0, 23)

  ! To bytes and back.
  bytes = transfer(3.14159_real64, [0_int8])
  print '(a, i0, a, *(1x, z2.2))', 'real64 as ', size(bytes), ' bytes:', bytes
  print '(a, f0.5)', 'restored            = ', transfer(bytes, 0.0_real64)

  ! Characters to integer.
  text = 'ABCD'
  print '(a, z8.8)', "'ABCD' as int32     = 0x", transfer(text, 0_int32)

  print '(a, 3(1x, i0))', 'storage_size (bits) of int8, real64, text:', &
      storage_size(0_int8), storage_size(0.0_real64), storage_size(text)
  print '(a, i0)', 'c_sizeof(c_double) (bytes) = ', c_sizeof(cd)

end program transfer_storage

! Output:
! bits of 1.0         = 0x3F800000
! back to real        = 1.0
! sign 1, exponent 2, mantissa 0x500000
! real64 as 8 bytes: 6E 86 1B F0 F9 21 09 40
! restored            = 3.14159
! 'ABCD' as int32     = 0x44434241
! storage_size (bits) of int8, real64, text: 8 64 32
! c_sizeof(c_double) (bytes) = 8
