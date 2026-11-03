! -----------------------------------------------------------------------------
! 06_assignment_and_equality.f90 - what is (and is not) built in
!
! Run:  scripts/run.sh 16-derived-types/06_assignment_and_equality.f90
! -----------------------------------------------------------------------------
!
! For every derived type you get for free:
!   * intrinsic ASSIGNMENT (=): component-wise, deep for allocatables,
!     shallow (pointer assignment) for pointer components;
!   * the structure constructor;
!   * passing as arguments, arrays of the type, I/O of simple types with
!     explicit or list-directed formats (each component in turn).
!
! You do NOT get ==, <, +, ... - define them with interface operator
! (chapter 12) or type-bound generics (chapter 19). Comparing components
! by hand is the usual minimal solution.

module colours
  implicit none (type, external)
  private
  public :: rgb, operator(==)

  type :: rgb
    integer :: r = 0, g = 0, b = 0
  end type rgb

  interface operator(==)
    module procedure rgb_equal
  end interface

contains

  elemental logical function rgb_equal(a, b)
    type(rgb), intent(in) :: a, b
    rgb_equal = a%r == b%r .and. a%g == b%g .and. a%b == b%b
  end function rgb_equal

end module colours

program assignment_and_equality
  use colours, only: rgb, operator(==)
  implicit none (type, external)

  type(rgb) :: red, copy
  type(rgb) :: palette(3)

  red = rgb(255, 0, 0)
  copy = red                                 ! intrinsic assignment
  print '(a, l1)', 'copy == red      : ', copy == red
  copy%g = 10
  print '(a, l1)', 'after change     : ', copy == red

  palette = [rgb(255, 0, 0), rgb(0, 255, 0), red]
  print '(a, *(1x, l1))', 'palette == red   :', palette == red
  print '(a, i0)', 'count of red     : ', count(palette == red)

  ! List-directed and formatted I/O handle simple derived types.
  print '(a, 3(1x, i0))', 'formatted output :', red
  print *, 'list-directed    :', red

end program assignment_and_equality

! Output:
! copy == red      : T
! after change     : F
! palette == red   : T F T
! count of red     : 2
! formatted output : 255 0 0
!  list-directed    :         255           0           0
