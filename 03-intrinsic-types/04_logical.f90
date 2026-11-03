! -----------------------------------------------------------------------------
! 04_logical.f90 - the LOGICAL type
!
! Run:  scripts/run.sh 03-intrinsic-types/04_logical.f90
! -----------------------------------------------------------------------------
!
! LOGICAL has two values: .true. and .false. (with optional kind suffix,
! e.g. .true._logical8). Logical values are NOT integers: there is no
! implicit conversion between them, and `if (n)` with integer n is an error.
!
! Operators (lowest to highest precedence):
!   .eqv. .neqv.   equivalence / exclusive or
!   .or.
!   .and.
!   .not.
!
! Kinds: logical(logical8/16/32/64) from iso_fortran_env (F2023 names) and
! selected_logical_kind(bits) (F2023). Mostly needed for C interop
! (c_bool) or for saving memory in huge masks.
!
! List-directed and L-format output print T / F.

program logical_type
  use, intrinsic :: iso_fortran_env, only: logical8, logical32
  implicit none (type, external)

  logical :: a, b
  logical(logical8) :: small_flag
  logical(selected_logical_kind(32)) :: wide_flag
  logical(logical32) :: also_wide
  integer :: n

  a = .true.
  b = .false.
  small_flag = .true._logical8
  wide_flag = a
  also_wide = .not. a

  print '(a, 2(1x, l1))', 'a, b              :', a, b
  print '(a, l1)', '.not. a           : ', .not. a
  print '(a, l1)', 'a .and. b         : ', a .and. b
  print '(a, l1)', 'a .or. b          : ', a .or. b
  print '(a, l1)', 'a .eqv. b         : ', a .eqv. b
  print '(a, l1)', 'a .neqv. b (xor)  : ', a .neqv. b

  ! Comparing logicals uses .eqv./.neqv., NOT == (== is for numbers).
  if (a .eqv. wide_flag) print '(a)', 'a .eqv. wide_flag'

  ! Relational operators produce default logical values.
  n = 5
  b = n > 3 .and. n < 10
  print '(a, l1)', '3 < n < 10        : ', b

  ! Converting between integer and logical has to be explicit:
  n = merge(1, 0, a)               ! logical -> integer
  b = (n /= 0)                     ! integer -> logical
  print '(a, i0, 1x, l1)', 'merge / compare   : ', n, b

  ! Converting between logical kinds: the LOGICAL intrinsic.
  small_flag = logical(also_wide, kind=logical8)
  print '(a, l1)', 'converted kind    : ', small_flag
  print '(a, 3(1x, i0))', 'storage bits      :', &
      storage_size(a), storage_size(small_flag), storage_size(wide_flag)

end program logical_type

! Output:
! a, b              : T F
! .not. a           : F
! a .and. b         : F
! a .or. b          : T
! a .eqv. b         : F
! a .neqv. b (xor)  : T
! a .eqv. wide_flag
! 3 < n < 10        : T
! merge / compare   : 1 T
! converted kind    : F
! storage bits      : 32 8 32
