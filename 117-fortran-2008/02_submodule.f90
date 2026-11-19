! @flags -std=f2008
! -----------------------------------------------------------------------------
! 02_submodule.f90 - the interface in the module, the body in the submodule
!
! Run:  scripts/run.sh 117-fortran-2008/02_submodule.f90
! -----------------------------------------------------------------------------

module parent_m
  implicit none

  interface
    module subroutine value(n)
      integer, intent(out) :: n
    end subroutine value
  end interface

end module parent_m

submodule (parent_m) child
contains

  module subroutine value(n)
    integer, intent(out) :: n
    n = 6
  end subroutine value

end submodule child

program f2008_submodule
  use parent_m
  implicit none

  integer :: n

  call value(n)
  print '(i0)', n

end program f2008_submodule

! Output:
! 6
