! -----------------------------------------------------------------------------
! 05_polymorphism.f90 - CLASS(...) and dynamic dispatch
!
! Run:  scripts/run.sh 18-oop-polymorphism/05_polymorphism.f90
! -----------------------------------------------------------------------------
!
! A POLYMORPHIC entity is declared CLASS(t). Its DECLARED type is t; its
! DYNAMIC type can be t or any extension of t, decided at run time.
!
!   class(shape), intent(in) :: s           dummy: accepts any shape
!   class(shape), allocatable :: s          dynamic type set by allocate
!   class(shape), pointer :: p              points at any shape target
!
! * Calling a binding (s%area()) dispatches on the DYNAMIC type.
! * Only the components of the declared type are accessible directly;
!   use SELECT TYPE (06_select_type.f90) to reach extension components.
! * allocate (circle :: s)                 type-spec chooses the dynamic type
!   allocate (s, source=circle(2.0))       copy type and value from a source
! * Fortran has no "array of pointers to base" built in: an array of
!   class(shape) has ONE dynamic type for all elements. For heterogeneous
!   collections wrap a polymorphic component in a type (shape_holder).

module shapes
  implicit none (type, external)

  type :: shape
  contains
    procedure :: area
    procedure :: name
  end type shape

  type, extends(shape) :: circle
    real :: r = 1
  contains
    procedure :: area => circle_area
    procedure :: name => circle_name
  end type circle

  type, extends(shape) :: rectangle
    real :: w = 1, h = 1
  contains
    procedure :: area => rectangle_area
    procedure :: name => rectangle_name
  end type rectangle

  type :: shape_holder                      ! heterogeneous-collection idiom
    class(shape), allocatable :: item
  end type shape_holder

contains

  real function area(self)
    class(shape), intent(in) :: self
    area = 0
  end function area

  function name(self) result(n)
    class(shape), intent(in) :: self
    character(len=:), allocatable :: n
    n = 'shape'
  end function name

  real function circle_area(self)
    class(circle), intent(in) :: self
    circle_area = acos(-1.0) * self%r**2
  end function circle_area

  function circle_name(self) result(n)
    class(circle), intent(in) :: self
    character(len=:), allocatable :: n
    n = 'circle'
  end function circle_name

  real function rectangle_area(self)
    class(rectangle), intent(in) :: self
    rectangle_area = self%w * self%h
  end function rectangle_area

  function rectangle_name(self) result(n)
    class(rectangle), intent(in) :: self
    character(len=:), allocatable :: n
    n = 'rectangle'
  end function rectangle_name

  subroutine report(s)                       ! works for every extension
    class(shape), intent(in) :: s
    print '(a12, a, f8.3)', s%name(), ': area =', s%area()
  end subroutine report

end module shapes

program polymorphism
  use shapes, only: shape, circle, rectangle, shape_holder, report
  implicit none (type, external)

  class(shape), allocatable :: s
  type(shape_holder) :: collection(3)
  integer :: i
  real :: total

  allocate (circle :: s)                     ! dynamic type: circle
  call report(s)
  deallocate (s)
  allocate (s, source=rectangle(2, 3))       ! dynamic type and value
  call report(s)

  collection(1)%item = circle(1.5)           ! polymorphic assignment (F2008)
  collection(2)%item = rectangle(4, 0.5)
  collection(3)%item = shape()

  total = 0
  do i = 1, size(collection)
    call report(collection(i)%item)
    total = total + collection(i)%item%area()
  end do
  print '(a, f0.3)', 'total area: ', total

end program polymorphism

! Output:
!       circle: area =   3.142
!    rectangle: area =   6.000
!       circle: area =   7.069
!    rectangle: area =   2.000
!        shape: area =   0.000
! total area: 9.069
