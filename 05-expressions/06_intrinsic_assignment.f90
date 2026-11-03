! -----------------------------------------------------------------------------
! 06_intrinsic_assignment.f90 - what `variable = expression` does
!
! Run:  scripts/run.sh 05-expressions/06_intrinsic_assignment.f90
! -----------------------------------------------------------------------------
!
! `=` is a statement, not an operator: it has no value and cannot be
! chained (`a = b = 0` is a syntax error).
!
! Intrinsic assignment rules:
!   * Numeric: the expression is evaluated in its own type/kind, THEN
!     converted to the variable's type/kind (truncation for integers).
!   * Character: padded with blanks or truncated to the variable's length;
!     a deferred-length allocatable takes the length of the value.
!   * Arrays: shapes must conform; a scalar is broadcast to every element.
!   * Allocatable variables are (re)allocated to the shape of the value
!     (F2003, see chapter 08).
!   * The right side is fully evaluated before anything is stored, so
!     overlapping assignments like a(2:4) = a(1:3) work as if copied.
!   * Derived types: component-by-component, deep-copying allocatables.
!   * Pointer assignment is a different statement: p => target.

program intrinsic_assignment
  use, intrinsic :: iso_fortran_env, only: dp => real64
  implicit none (type, external)

  integer :: n
  real(dp) :: x
  character(len=4) :: short
  character(len=:), allocatable :: flexible
  integer :: a(5)
  integer, allocatable :: grown(:)

  ! Numeric conversion on assignment.
  n = 7.9_dp                       ! truncates to 7 (warning with -Wall)
  x = 7 / 2                        ! integer division first: 3.0
  print '(a, i0, a, f0.1)', 'n = ', n, ', x = ', x

  ! Character padding / truncation.
  short = 'ab'
  print '(3a)', '[', short, ']'
  short = 'abcdefgh'
  print '(3a)', '[', short, ']'
  flexible = 'abcdefgh'
  print '(3a, i0)', '[', flexible, '] len=', len(flexible)

  ! Scalar broadcast and overlapping sections.
  a = 0
  a = [1, 2, 3, 4, 5]
  a(2:5) = a(1:4)                  ! behaves as if the RHS were copied first
  print '(a, *(1x, i0))', 'shifted:', a

  ! Reallocation on assignment.
  grown = [1, 2]
  print '(a, i0)', 'size after [1,2]      : ', size(grown)
  grown = [grown, 3, 4, 5]
  print '(a, i0)', 'size after appending  : ', size(grown)

  ! Because the RHS is evaluated first, a vector subscript can swap
  ! elements without an explicit temporary.
  a = [1, 2, 3, 4, 5]
  a(1:2) = a([2, 1])
  print '(a, *(1x, i0))', 'swapped first two:', a

end program intrinsic_assignment

! Output:
! n = 7, x = 3.0
! [ab  ]
! [abcd]
! [abcdefgh] len=8
! shifted: 1 1 2 3 4
! size after [1,2]      : 2
! size after appending  : 5
! swapped first two: 2 1 3 4 5
