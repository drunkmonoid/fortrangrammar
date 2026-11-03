! -----------------------------------------------------------------------------
! 04_type_bound_operators.f90 - operators and assignment bound to a type
!
! Run:  scripts/run.sh 19-oop-advanced/04_type_bound_operators.f90
! -----------------------------------------------------------------------------
!
!   generic :: operator(+) => add
!   generic :: operator(==) => equals
!   generic :: operator(.dot.) => dot
!   generic :: assignment(=) => assign_from_real
!
! Compared with `interface operator(+)` in the module (chapter 12):
!   * the operator travels WITH THE TYPE: any scope that has the type has
!     the operator, no `use, only: operator(+)` needed;
!   * extensions inherit it and may override the specifics;
!   * the passed object is one operand; use pass(arg) when the object is the
!     second operand (e.g. real * vec).

module vec_mod
  implicit none (type, external)
  private
  public :: vec

  type :: vec
    real :: x = 0, y = 0
  contains
    procedure, private :: add, sub, scale_right, equals, dot, from_real
    procedure, private, pass(v) :: scale_left
    generic :: operator(+) => add
    generic :: operator(-) => sub
    generic :: operator(*) => scale_right, scale_left
    generic :: operator(==) => equals
    generic :: operator(.dot.) => dot
    generic :: assignment(=) => from_real
  end type vec

contains

  elemental type(vec) function add(a, b)
    class(vec), intent(in) :: a, b
    add = vec(a%x + b%x, a%y + b%y)
  end function add

  elemental type(vec) function sub(a, b)
    class(vec), intent(in) :: a, b
    sub = vec(a%x - b%x, a%y - b%y)
  end function sub

  elemental type(vec) function scale_right(a, k)
    class(vec), intent(in) :: a
    real, intent(in) :: k
    scale_right = vec(a%x * k, a%y * k)
  end function scale_right

  elemental type(vec) function scale_left(k, v)
    real, intent(in) :: k
    class(vec), intent(in) :: v
    scale_left = vec(v%x * k, v%y * k)
  end function scale_left

  elemental logical function equals(a, b)
    class(vec), intent(in) :: a, b
    equals = a%x == b%x .and. a%y == b%y
  end function equals

  elemental real function dot(a, b)
    class(vec), intent(in) :: a, b
    dot = a%x * b%x + a%y * b%y
  end function dot

  elemental subroutine from_real(lhs, r)
    class(vec), intent(inout) :: lhs
    real, intent(in) :: r
    lhs%x = r
    lhs%y = r
  end subroutine from_real

end module vec_mod

program type_bound_operators
  use vec_mod, only: vec                 ! operators come with the type
  implicit none (type, external)

  type(vec) :: a, b, c

  a = vec(1, 2)
  b = vec(3, -1)
  c = a + b
  print '(a, 2(1x, f0.1))', 'a + b      =', c
  c = 2.0 * a - b
  print '(a, 2(1x, f0.1))', '2*a - b    =', c
  c = a * 0.5
  print '(a, 2(1x, f0.1))', 'a * 0.5    =', c
  print '(a, f0.1)', 'a .dot. b  = ', a .dot. b
  print '(a, l1)', 'a == a     : ', a == a
  c = 7.0                                ! defined assignment from real
  print '(a, 2(1x, f0.1))', 'c = 7.0    =', c

end program type_bound_operators

! Output:
! a + b      = 4.0 1.0
! 2*a - b    = -1.0 5.0
! a * 0.5    = .5 1.0
! a .dot. b  = 1.0
! a == a     : T
! c = 7.0    = 7.0 7.0
