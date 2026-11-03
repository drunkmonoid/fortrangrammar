! -----------------------------------------------------------------------------
! 05_ford_documented.f90 - source annotated for FORD
!
! Run:  scripts/run.sh 30-ecosystem/05_ford_documented.f90
! Docs: pip install ford && ford project.md   (see 05_ford.md)
! -----------------------------------------------------------------------------
!
! FORD (FORtran Documenter) builds HTML documentation from the code and
! special comments:
!   !!   documents the entity ABOVE (after it), the default "docmark"
!   !>   documents the entity BELOW (before it), the "predocmark"
! Markdown and LaTeX math ($...$) are allowed inside doc comments.
! Ordinary `!` comments are ignored by FORD.

!> Simple 2-D geometry.
!>
!> Provides a `point` type and the Euclidean distance between points.
module geometry_doc
  implicit none (type, external)
  private
  public :: point, distance

  !> A point in the plane.
  type :: point
    real :: x = 0  !! abscissa
    real :: y = 0  !! ordinate
  end type point

contains

  !> Euclidean distance $\sqrt{(x_2-x_1)^2 + (y_2-y_1)^2}$.
  pure real function distance(a, b)
    type(point), intent(in) :: a  !! first point
    type(point), intent(in) :: b  !! second point
    distance = hypot(b%x - a%x, b%y - a%y)
  end function distance

end module geometry_doc

!> Example driver for the documented module.
program ford_documented
  use geometry_doc, only: point, distance
  implicit none (type, external)
  print '(a, f0.2)', 'distance = ', distance(point(0, 0), point(3, 4))
end program ford_documented

! Output:
! distance = 5.00
