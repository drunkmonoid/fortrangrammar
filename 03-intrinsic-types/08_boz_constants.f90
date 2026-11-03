! -----------------------------------------------------------------------------
! 08_boz_constants.f90 - binary, octal and hexadecimal constants
!
! Run:  scripts/run.sh 03-intrinsic-types/08_boz_constants.f90
! -----------------------------------------------------------------------------
!
! BOZ literal constants:   b'1011'   o'777'   z'ff'   (or with " quotes)
! Upper or lower case letters are fine: Z'FF'.
!
! A BOZ constant is a bit pattern with NO type. It may appear only where its
! meaning is clear. Fortran 2018:
!   * as an argument to int, real, dble, cmplx       (int(z'ff'))
!   * as an argument to bit intrinsics              (iand(n, z'0f'))
!   * in a DATA statement
! Fortran 2023 adds (NOT yet accepted by gfortran 15 -> use int(z'..')):
!   * initialisation / assignment of an integer or real   (integer :: m = z'ff')
!   * array constructors with a type spec           ([integer :: z'1', z'2'])
!   * enumerator values
!
! The suffix form `1Fh` / `X'..'` of some compilers is not standard.
!
! For output in those bases use the B, O and Z edit descriptors (chapter 22).

program boz_constants
  use, intrinsic :: iso_fortran_env, only: int32, real32
  implicit none (type, external)

  integer :: mask = int(z'00ff')   ! F2023 allows plain = z'00ff'
  integer :: flags
  real(real32) :: one

  print '(a, i0)', "b'1011' = ", int(b'1011')
  print '(a, i0)', "o'777'  = ", int(o'777')
  print '(a, i0)', "z'ff'   = ", int(z'ff')
  print '(a, i0)', 'mask    = ', mask

  ! Bit intrinsics accept BOZ directly.
  flags = int(z'1234')
  print '(a, z0)', 'flags & 0x00ff = 0x', iand(flags, z'00ff')

  ! real(boz) reinterprets the BITS (it does not convert the number):
  ! 3F800000 is the IEEE single-precision bit pattern of 1.0.
  one = real(z'3F800000', kind=real32)
  print '(a, f0.1)', "real(z'3F800000') = ", one

  ! Output in other bases.
  print '(a, b0, 1x, o0, 1x, z0)', '42 as b/o/z: ', 42, 42, 42

  print '(a, *(1x, i0))', 'typed constructor:', [integer(int32) :: int(z'a'), int(z'b'), int(z'c')]

end program boz_constants

! Output:
! b'1011' = 11
! o'777'  = 511
! z'ff'   = 255
! mask    = 255
! flags & 0x00ff = 0x34
! real(z'3F800000') = 1.0
! 42 as b/o/z: 101010 52 2A
! typed constructor: 10 11 12
