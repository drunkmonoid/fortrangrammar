! -----------------------------------------------------------------------------
! 06_select_type.f90 - SELECT TYPE
!
! Run:  scripts/run.sh 18-oop-polymorphism/06_select_type.f90
! -----------------------------------------------------------------------------
!
!   select type (x)               or   select type (alias => expr)
!   type is (circle)              exact dynamic type circle
!     ...x is type(circle) here, all its components accessible
!   class is (rectangle)          rectangle OR any extension of it
!     ...x is class(rectangle) here
!   type is (integer)             intrinsic types (for class(*), ch. 20)
!   class default                 anything else
!   end select
!
! Selection: an exact TYPE IS match wins; otherwise the most specific
! (most-extended) matching CLASS IS; otherwise CLASS DEFAULT. At most one
! block runs. Inside each block the selector has the selected type.
!
! Prefer type-bound procedures for behaviour that varies by type; use
! SELECT TYPE when you need the concrete components, or when the set of
! types is not yours to extend.

module shapes
  implicit none (type, external)
  type :: shape
  end type shape
  type, extends(shape) :: circle
    real :: r = 1
  end type circle
  type, extends(shape) :: rectangle
    real :: w = 1, h = 1
  end type rectangle
  type, extends(rectangle) :: square
  end type square
end module shapes

program select_type_demo
  use shapes, only: shape, circle, rectangle, square
  implicit none (type, external)

  type :: holder
    class(shape), allocatable :: s
  end type holder

  type(holder) :: items(4)
  integer :: i

  items(1)%s = circle(2)
  items(2)%s = rectangle(2, 3)
  items(3)%s = square(4, 4)
  items(4)%s = shape()

  do i = 1, size(items)
    select type (s => items(i)%s)
    type is (circle)
      print '(a, f0.1)', 'circle with radius ', s%r
    type is (square)
      print '(a, f0.1)', 'square with side ', s%w
    class is (rectangle)                     ! rectangle or other extensions
      print '(a, f0.1, a, f0.1)', 'rectangle ', s%w, ' x ', s%h
    class default
      print '(a)', 'some other shape'
    end select
  end do

end program select_type_demo

! Output:
! circle with radius 2.0
! rectangle 2.0 x 3.0
! square with side 4.0
! some other shape
