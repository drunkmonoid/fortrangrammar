! Exercise 18: extended type overriding a type-bound procedure, dispatched via class(...) and select type.

module ex18_m
  implicit none (type, external)
  private
  public :: shape_t, rect_t, square_t

  type :: shape_t
  contains
    procedure :: area => shape_area
  end type shape_t

  type, extends(shape_t) :: rect_t
    integer :: w = 0
    integer :: h = 0
  contains
    procedure :: area => rect_area
  end type rect_t

  type, extends(shape_t) :: square_t
    integer :: side = 0
  contains
    procedure :: area => square_area
  end type square_t

contains

  pure integer function shape_area(self)
    class(shape_t), intent(in) :: self
    shape_area = merge(0, -1, same_type_as(self, self))
  end function shape_area

  pure integer function rect_area(self)
    class(rect_t), intent(in) :: self
    rect_area = self%w * self%h
  end function rect_area

  pure integer function square_area(self)
    class(square_t), intent(in) :: self
    square_area = self%side * self%side
  end function square_area

end module ex18_m

program ex18_oop_polymorphism
  use, intrinsic :: iso_fortran_env, only: output_unit
  use ex18_m, only: shape_t, rect_t, square_t
  implicit none (type, external)

  class(shape_t), allocatable :: s1, s2
  integer :: is_sq

  s1 = rect_t(w=3, h=5)
  s2 = square_t(side=4)

  is_sq = 0
  select type (s2)
  type is (square_t)
    is_sq = 1
  end select

  write(output_unit, '(i0,1x,i0,1x,i0)') s1%area(), s2%area(), is_sq

end program ex18_oop_polymorphism

! Output:
! 15 16 1
