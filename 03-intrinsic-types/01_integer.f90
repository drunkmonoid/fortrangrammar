! -----------------------------------------------------------------------------
! 01_integer.f90 - the INTEGER type
!
! Run:  scripts/run.sh 03-intrinsic-types/01_integer.f90
! -----------------------------------------------------------------------------
!
! INTEGER holds signed whole numbers. Its size is chosen with a KIND
! parameter. The kind numbers themselves are compiler-specific (gfortran uses
! the byte size: 1, 2, 4, 8, 16), so never write `integer(8)` - use the named
! constants from iso_fortran_env or selected_int_kind.
!
! Literal constants:
!   42           default integer kind
!   -42          a unary minus applied to 42 (literals are unsigned)
!   42_int64     kind suffix: the literal has kind int64
!   1000000_i8   any integer named constant can be the suffix
!
! Integer arithmetic does not detect overflow: exceeding huge() is undefined
! behaviour (in practice it usually wraps). Check ranges yourself.
!
! The standard model is symmetric: -huge(i) .. huge(i). Most hardware also
! represents -huge(i)-1, but that value is outside the model.

program integer_type
  use, intrinsic :: iso_fortran_env, only: int8, int16, int32, int64
  implicit none (type, external)

  integer :: default_int          ! default kind (32 bits on all mainstream compilers)
  integer(kind=int8) :: tiny_int
  integer(int16) :: small_int     ! "kind=" is optional
  integer(int32) :: medium_int
  integer(int64) :: big_int
  integer, parameter :: i8 = selected_int_kind(18)  ! >= 18 decimal digits
  integer(i8) :: also_big

  default_int = 42
  tiny_int = 127_int8
  small_int = -32767_int16
  medium_int = 2147483647_int32
  big_int = 9223372036854775807_int64
  also_big = 1000000000000_i8

  print '(a, i0)', 'default kind number: ', kind(default_int)
  print '(a, i0)', 'int8  max: ', huge(tiny_int)
  print '(a, i0)', 'int16 max: ', huge(small_int)
  print '(a, i0)', 'int32 max: ', huge(medium_int)
  print '(a, i0)', 'int64 max: ', huge(big_int)
  print '(a, i0)', 'selected_int_kind(18) gives kind ', i8
  print '(a, i0)', 'also_big = ', also_big

  ! Decimal digits guaranteed by each kind.
  print '(a, 4(1x, i0))', 'range() of int8/16/32/64:', &
      range(tiny_int), range(small_int), range(medium_int), range(big_int)

  ! A literal without a suffix has default kind. 3000000000 does not fit in
  ! 32 bits, so it must carry the suffix:
  big_int = 3000000000_int64
  print '(a, i0)', 'needs suffix: ', big_int

  ! Integer division truncates toward zero.
  print '(a, i0, 1x, i0)', '7/2, -7/2 = ', 7 / 2, -7 / 2

end program integer_type

! Output:
! default kind number: 4
! int8  max: 127
! int16 max: 32767
! int32 max: 2147483647
! int64 max: 9223372036854775807
! selected_int_kind(18) gives kind 8
! also_big = 1000000000000
! range() of int8/16/32/64: 2 4 9 18
! needs suffix: 3000000000
! 7/2, -7/2 = 3 -3
