! -----------------------------------------------------------------------------
! 06_kind_arrays.f90 - discover every kind the compiler supports
!
! Run:  scripts/run.sh 03-intrinsic-types/06_kind_arrays.f90
! -----------------------------------------------------------------------------
!
! iso_fortran_env (F2008) has named constant ARRAYS listing all supported
! kind values of each intrinsic type:
!
!   integer_kinds  real_kinds  logical_kinds  character_kinds
!
! Complex kinds equal the real kinds. Named kind constants are negative when
! the kind is not supported: -1 (no such size), -2 (size exists but with a
! different precision/representation). real16 below is an example.

program kind_arrays
  use, intrinsic :: iso_fortran_env, only: integer_kinds, real_kinds, &
                                           logical_kinds, character_kinds, &
                                           int8, int16, int32, int64, &
                                           real16, real32, real64, real128
  implicit none (type, external)

  print '(a, *(1x, i0))', 'integer_kinds  :', integer_kinds
  print '(a, *(1x, i0))', 'real_kinds     :', real_kinds
  print '(a, *(1x, i0))', 'logical_kinds  :', logical_kinds
  print '(a, *(1x, i0))', 'character_kinds:', character_kinds
  print '(a, *(1x, i0))', 'int8..int64    :', int8, int16, int32, int64
  print '(a, *(1x, i0))', 'real16..real128:', real16, real32, real64, real128

  ! A kind that is in real_kinds but has no iso_fortran_env name: gfortran's
  ! 80-bit extended precision. Find it portably with selected_real_kind.
  print '(a, i0)', 'selected_real_kind(18) = ', selected_real_kind(18)

  ! Requests that cannot be satisfied return negative values:
  !   -1  precision not available     -2  range not available
  !   -3  neither                     -4  each alone, not both
  !   -5  radix not available
  print '(a, i0)', 'selected_real_kind(p=50)  = ', selected_real_kind(p=50)
  print '(a, i0)', 'selected_real_kind(r=9999)= ', selected_real_kind(r=9999)
  print '(a, i0)', 'selected_int_kind(40)     = ', selected_int_kind(40)

end program kind_arrays

! Output:
! integer_kinds  : 1 2 4 8 16
! real_kinds     : 4 8 10 16
! logical_kinds  : 1 2 4 8 16
! character_kinds: 1 4
! int8..int64    : 1 2 4 8
! real16..real128: -2 4 8 16
! selected_real_kind(18) = 10
! selected_real_kind(p=50)  = -1
! selected_real_kind(r=9999)= -2
! selected_int_kind(40)     = -1
