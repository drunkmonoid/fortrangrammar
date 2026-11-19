! @flags -std=f2003
! -----------------------------------------------------------------------------
! 01_types.f90 - extension, a deferred-length character, move_alloc
!
! Run:  scripts/run.sh 116-fortran-2003/01_types.f90
! -----------------------------------------------------------------------------

module shapes_m
  implicit none

  type :: shape
  contains
    procedure :: sides => shape_sides
  end type shape

  type, extends(shape) :: triangle
    integer, allocatable :: edges(:)
  contains
    procedure :: sides => triangle_sides
  end type triangle

contains

  integer function shape_sides(this)
    class(shape), intent(in) :: this
    shape_sides = 0
  end function shape_sides

  integer function triangle_sides(this)
    class(triangle), intent(in) :: this
    triangle_sides = size(this%edges)
  end function triangle_sides

end module shapes_m

program f2003_types
  use shapes_m
  implicit none

  type(triangle) :: item
  class(shape), allocatable :: held
  character(len=:), allocatable :: name
  integer, allocatable :: scratch(:)

  allocate (item%edges(3))
  item%edges = (/ 1, 1, 1 /)
  allocate (held, source=item)
  name = 'tri'
  allocate (scratch(2))
  scratch = (/ 4, 5 /)
  call move_alloc(scratch, item%edges)
  print '(i0, 1x, i0, 1x, i0)', held%sides(), len(name), sum(item%edges)

end program f2003_types

! Output:
! 3 3 9
