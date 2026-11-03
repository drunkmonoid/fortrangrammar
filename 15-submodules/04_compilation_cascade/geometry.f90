! geometry.f90 - the module: interfaces only. Changes here force every user
! to recompile; changes in the submodule do not.
module geometry
  implicit none (type, external)
  private
  public :: distance

  interface
    module pure real function distance(x1, y1, x2, y2)
      real, intent(in) :: x1, y1, x2, y2
    end function distance
  end interface
end module geometry
