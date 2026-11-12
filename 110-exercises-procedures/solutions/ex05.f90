! Exercise 15: parent module interface separated from submodule implementation.

module ex15_iface_m
  implicit none (type, external)
  private
  public :: manhattan_dist

  interface
    pure module integer function manhattan_dist(x1, y1, x2, y2)
      integer, intent(in) :: x1, y1, x2, y2
    end function manhattan_dist
  end interface

end module ex15_iface_m

submodule (ex15_iface_m) ex15_impl_sm
  implicit none (type, external)
contains
  module procedure manhattan_dist
    manhattan_dist = abs(x1 - x2) + abs(y1 - y2)
  end procedure manhattan_dist
end submodule ex15_impl_sm

program ex15_submodules
  use, intrinsic :: iso_fortran_env, only: output_unit
  use ex15_iface_m, only: manhattan_dist
  implicit none (type, external)

  write(output_unit, '(a,1x,i0)') 'distance:', manhattan_dist(2, 5, -1, 1)

end program ex15_submodules

! Output:
! distance: 7
