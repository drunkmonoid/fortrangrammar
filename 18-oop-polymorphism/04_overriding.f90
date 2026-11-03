! -----------------------------------------------------------------------------
! 04_overriding.f90 - overriding inherited bindings
!
! Run:  scripts/run.sh 18-oop-polymorphism/04_overriding.f90
! -----------------------------------------------------------------------------
!
! A child type overrides a parent binding by declaring a binding with the
! SAME NAME. The overriding procedure must have the same interface, except
! that its passed-object dummy is class(child).
!
! Calling the parent's version from an override ("super") - two ways,
! with DIFFERENT results (the output below shows both):
!
!   call self%shape%describe()   passes the PARENT COMPONENT, whose type is
!                                exactly shape. Everything called inside
!                                dispatches to shape's bindings, so its
!                                self%area() returns shape's 0.
!   call shape_describe(self)    calls the parent's implementation with the
!                                whole object, still class(circle): calls
!                                inside dispatch to circle's overrides.
!                                Usually what you want; needs the specific
!                                procedure to be accessible.
!
! NON_OVERRIDABLE (chapter 19) forbids overriding.

module shapes
  implicit none (type, external)

  type :: shape
    character(len=12) :: label = 'shape'
  contains
    procedure :: area => shape_area
    procedure :: describe => shape_describe
  end type shape

  type, extends(shape) :: circle
    real :: r = 1
  contains
    procedure :: area => circle_area             ! override
    procedure :: describe => circle_describe     ! override that calls parent
  end type circle

contains

  real function shape_area(self)
    class(shape), intent(in) :: self
    shape_area = 0
  end function shape_area

  subroutine shape_describe(self)
    class(shape), intent(in) :: self
    print '(3a, f0.3)', '[', trim(self%label), '] area = ', self%area()
  end subroutine shape_describe

  real function circle_area(self)
    class(circle), intent(in) :: self
    circle_area = acos(-1.0) * self%r**2
  end function circle_area

  subroutine circle_describe(self)
    class(circle), intent(in) :: self
    write (*, '(a)', advance='no') 'via self%shape%describe(): '
    call self%shape%describe()                   ! parent component: area 0
    write (*, '(a)', advance='no') 'via shape_describe(self) : '
    call shape_describe(self)                    ! whole object: circle area
    print '(a, f0.2)', '    radius = ', self%r
  end subroutine circle_describe

end module shapes

program overriding
  use shapes, only: shape, circle
  implicit none (type, external)

  type(shape) :: s
  type(circle) :: c

  c%label = 'circle'
  c%r = 2

  call s%describe()
  call c%describe()

end program overriding

! Output:
! [shape] area = .000
! via self%shape%describe(): [circle] area = .000
! via shape_describe(self) : [circle] area = 12.566
!     radius = 2.00
