! Exercise 16: derived type with default component + allocatable component + keyword constructor.

module ex16_m
  implicit none (type, external)
  private
  public :: bag_t

  type :: bag_t
    integer :: tag = 100
    integer, allocatable :: items(:)
  end type bag_t

end module ex16_m

program ex16_derived_types
  use, intrinsic :: iso_fortran_env, only: output_unit
  use ex16_m, only: bag_t
  implicit none (type, external)

  type(bag_t) :: b

  b = bag_t(items=[10, 20, 30])
  write(output_unit, '(a,1x,i0,1x,i0)') 'tag, sum:', b%tag, sum(b%items)

end program ex16_derived_types

! Output:
! tag, sum: 100 60
