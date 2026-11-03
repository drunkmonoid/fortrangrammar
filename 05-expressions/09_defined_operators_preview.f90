! -----------------------------------------------------------------------------
! 09_defined_operators_preview.f90 - your own operators (preview)
!
! Run:  scripts/run.sh 05-expressions/09_defined_operators_preview.f90
! -----------------------------------------------------------------------------
!
! You can:
!   * define new operators  .name.  (letters only, up to 63 chars), unary or
!     binary, for any types;
!   * extend intrinsic operators (+, *, ==, //, .and., ...) to new type
!     combinations - but not change what they do on intrinsic types.
!
! Both use `interface operator(...)` with functions whose arguments are
! intent(in). Precedence of a NEW operator is fixed: unary binds tightest,
! binary loosest (see 05_operator_precedence.f90). Extended intrinsic
! operators keep their usual precedence.
!
! Chapter 12 covers generics and operators in full; chapter 19 binds them
! to types.

module vectors
  implicit none (type, external)
  private
  public :: vec3, operator(+), operator(.dot.), operator(.cross.), operator(.norm.)

  type :: vec3
    real :: x = 0, y = 0, z = 0
  end type vec3

  interface operator(+)
    module procedure add
  end interface

  interface operator(.dot.)
    module procedure dot
  end interface

  interface operator(.cross.)
    module procedure cross
  end interface

  interface operator(.norm.)            ! unary
    module procedure norm
  end interface

contains

  pure type(vec3) function add(a, b)
    type(vec3), intent(in) :: a, b
    add = vec3(a%x + b%x, a%y + b%y, a%z + b%z)
  end function add

  pure real function dot(a, b)
    type(vec3), intent(in) :: a, b
    dot = a%x * b%x + a%y * b%y + a%z * b%z
  end function dot

  pure type(vec3) function cross(a, b)
    type(vec3), intent(in) :: a, b
    cross = vec3(a%y * b%z - a%z * b%y, a%z * b%x - a%x * b%z, a%x * b%y - a%y * b%x)
  end function cross

  pure real function norm(a)
    type(vec3), intent(in) :: a
    norm = sqrt(a .dot. a)
  end function norm

end module vectors

program defined_operators_preview
  use vectors, only: vec3, operator(+), operator(.dot.), operator(.cross.), operator(.norm.)
  implicit none (type, external)

  type(vec3) :: i_hat, j_hat, k_hat, s

  i_hat = vec3(1, 0, 0)
  j_hat = vec3(0, 1, 0)
  k_hat = i_hat .cross. j_hat
  s = i_hat + j_hat + k_hat

  print '(a, 3(1x, f0.1))', 'i x j      =', k_hat
  print '(a, 3(1x, f0.1))', 'i + j + k  =', s
  print '(a, f0.1)', 'i . j      = ', i_hat .dot. j_hat
  print '(a, f0.4)', '|i + j + k| = ', .norm. s

  ! Precedence: .norm. (unary) binds tighter than + and *, so
  ! .norm. s * 2.0 is (.norm. s) * 2.0.
  print '(a, f0.4)', '.norm. s * 2 = ', .norm. s * 2.0

end program defined_operators_preview
