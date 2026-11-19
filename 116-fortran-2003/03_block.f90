! @build fail
! @flags -std=f2003
! -----------------------------------------------------------------------------
! 03_block.f90 - block is Fortran 2008
!
! Run:  scripts/run.sh 116-fortran-2003/03_block.f90
! -----------------------------------------------------------------------------

program uses_block
  implicit none

  integer :: n

  n = 0
  block
    integer :: local
    local = 1
    n = local
  end block
  print '(i0)', n

end program uses_block
