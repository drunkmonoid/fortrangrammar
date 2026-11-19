! -----------------------------------------------------------------------------
! 01_sample.f90 - a program already in the repository style
!
! Run:  scripts/run.sh 112-lint/01_sample.f90
! -----------------------------------------------------------------------------

program lint_sample
  implicit none (type, external)

  integer :: n

  n = 2 + 2
  print '(a, i0)', 'n = ', n

end program lint_sample

! Output:
! n = 4
