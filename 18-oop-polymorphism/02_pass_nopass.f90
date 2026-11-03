! -----------------------------------------------------------------------------
! 02_pass_nopass.f90 - PASS, PASS(arg) and NOPASS bindings
!
! Run:  scripts/run.sh 18-oop-polymorphism/02_pass_nopass.f90
! -----------------------------------------------------------------------------
!
!   procedure :: f                  object passed as the FIRST argument
!   procedure, pass(obj) :: g       object passed as the dummy named obj,
!                                   wherever it is in the argument list
!   procedure, nopass :: h          object NOT passed: a "static method",
!                                   called as x%h(...) but sees no object
!
! PASS(arg) is useful when the natural argument order puts the object
! later, e.g. scale(factor, vector), or for binary operators where the
! object is the right-hand operand.

module vectors
  implicit none (type, external)
  private
  public :: vec2

  type :: vec2
    real :: x = 0, y = 0
  contains
    procedure :: length
    procedure, pass(v) :: scaled_by
    procedure, nopass :: unit_x
  end type vec2

contains

  real function length(self)
    class(vec2), intent(in) :: self
    length = hypot(self%x, self%y)
  end function length

  function scaled_by(factor, v) result(r)
    real, intent(in) :: factor
    class(vec2), intent(in) :: v          ! passed object is the 2nd dummy
    type(vec2) :: r
    r = vec2(factor * v%x, factor * v%y)
  end function scaled_by

  function unit_x() result(r)             ! no object argument at all
    type(vec2) :: r
    r = vec2(1, 0)
  end function unit_x

end module vectors

program pass_nopass
  use vectors, only: vec2
  implicit none (type, external)

  type(vec2) :: v, w

  v = vec2(3, 4)
  print '(a, f0.1)', 'v%length()        = ', v%length()
  w = v%scaled_by(2.0)                    ! calls scaled_by(2.0, v)
  print '(a, 2(1x, f0.1))', 'v%scaled_by(2.0)  =', w
  w = v%unit_x()                          ! v is not passed
  print '(a, 2(1x, f0.1))', 'v%unit_x()        =', w

end program pass_nopass

! Output:
! v%length()        = 5.0
! v%scaled_by(2.0)  = 6.0 8.0
! v%unit_x()        = 1.0 .0
