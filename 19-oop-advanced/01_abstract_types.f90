! -----------------------------------------------------------------------------
! 01_abstract_types.f90 - ABSTRACT types and DEFERRED bindings
!
! Run:  scripts/run.sh 19-oop-advanced/01_abstract_types.f90
! -----------------------------------------------------------------------------
!
!   type, abstract :: shape
!   contains
!     procedure(area_iface), deferred :: area     ! no implementation here
!     procedure :: describe                       ! may use area()
!   end type shape
!
!   abstract interface
!     real function area_iface(self)
!       import :: shape
!       class(shape), intent(in) :: self
!     end function
!   end interface
!
! * An abstract type cannot be instantiated: no type(shape) variables, no
!   shape(...) constructor - only class(shape) dummies, pointers and
!   allocatables, whose dynamic type is a concrete extension.
! * A DEFERRED binding gives the interface; every non-abstract extension
!   MUST override it.
! * Concrete bindings in the abstract type (describe) can call deferred ones:
!   the "template method" pattern.

module shapes
  implicit none (type, external)
  private
  public :: shape, circle, square

  type, abstract :: shape
  contains
    procedure(area_iface), deferred :: area
    procedure(name_iface), deferred :: name
    procedure :: describe
  end type shape

  abstract interface
    real function area_iface(self)
      import :: shape
      class(shape), intent(in) :: self
    end function area_iface

    function name_iface(self) result(n)
      import :: shape
      class(shape), intent(in) :: self
      character(len=:), allocatable :: n
    end function name_iface
  end interface

  type, extends(shape) :: circle
    real :: r = 1
  contains
    procedure :: area => circle_area
    procedure :: name => circle_name
  end type circle

  type, extends(shape) :: square
    real :: side = 1
  contains
    procedure :: area => square_area
    procedure :: name => square_name
  end type square

contains

  subroutine describe(self)
    class(shape), intent(in) :: self
    print '(a, a, f0.3)', self%name(), ' with area ', self%area()
  end subroutine describe

  real function circle_area(self)
    class(circle), intent(in) :: self
    circle_area = acos(-1.0) * self%r**2
  end function circle_area

  function circle_name(self) result(n)
    class(circle), intent(in) :: self
    character(len=:), allocatable :: n
    n = 'circle'
  end function circle_name

  real function square_area(self)
    class(square), intent(in) :: self
    square_area = self%side**2
  end function square_area

  function square_name(self) result(n)
    class(square), intent(in) :: self
    character(len=:), allocatable :: n
    n = 'square'
  end function square_name

end module shapes

program abstract_types
  use shapes, only: shape, circle, square
  implicit none (type, external)

  class(shape), allocatable :: s
  ! type(shape) :: bad        <- error: shape is abstract

  s = circle(1.0)
  call s%describe()
  s = square(3.0)
  call s%describe()

end program abstract_types

! Output:
! circle with area 3.142
! square with area 9.000
