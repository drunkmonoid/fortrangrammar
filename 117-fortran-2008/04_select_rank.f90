! @build fail
! @flags -std=f2008
! -----------------------------------------------------------------------------
! 04_select_rank.f90 - select rank is Fortran 2018
!
! Run:  scripts/run.sh 117-fortran-2008/04_select_rank.f90
! -----------------------------------------------------------------------------

program uses_select_rank
  implicit none

  integer :: n

  n = 3
  call show(n)

contains

  subroutine show(a)
    integer, intent(in) :: a(..)
    select rank (a)
    rank (0)
      print '(i0)', a
    rank default
      print '(i0)', 0
    end select
  end subroutine show

end program uses_select_rank
