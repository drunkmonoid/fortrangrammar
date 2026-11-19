! @flags -std=f95
! -----------------------------------------------------------------------------
! 01_features.f90 - free form, a module, an allocatable, elemental, forall
!
! Run:  scripts/run.sh 115-fortran-90-95/01_features.f90
! -----------------------------------------------------------------------------
!
! (/ /) is the Fortran 95 array constructor. [ ] arrives in Fortran 2003.

module demo_m
  implicit none

  type :: pair
    integer :: left
    integer :: right
  end type pair

contains

  pure elemental integer function add(x, y)
    integer, intent(in) :: x, y
    add = x + y
  end function add

end module demo_m

program f95_features
  use demo_m
  implicit none

  integer, allocatable :: values(:)
  integer :: squares(3), i
  type(pair) :: item

  allocate (values(3))
  values = (/ 1, 2, 3 /)
  values = values + 1
  forall (i = 1:3)
    squares(i) = values(i) * values(i)
  end forall
  item%left = add(2, 3)
  item%right = sum(squares)
  print '(i0, 1x, i0)', item%left, item%right

end program f95_features

! Output:
! 5 29
