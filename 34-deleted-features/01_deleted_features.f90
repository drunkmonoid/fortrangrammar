! @build fail
! -----------------------------------------------------------------------------
! 01_deleted_features.f90 - forms -std=f2023 must reject
!
! Try: scripts/run.sh 34-deleted-features/01_deleted_features.f90
! -----------------------------------------------------------------------------
!
! gfortran 15 reports, in order:
!
!   Error: Deleted feature: ASSIGN statement
!   Error: Deleted feature: Assigned GOTO statement
!   Error: Deleted feature: PAUSE statement
!   Error: Fortran 2018 deleted feature: Arithmetic IF statement
!   Error: Deleted feature: Loop variable must be integer
!   Error: Fortran 2018 deleted feature: Shared DO termination label
!
! Replacements: select case, an integer do, nested block dos, error stop.
! Chapters 06 and 33. The same text compiles with -std=legacy; that file
! is 02_deleted_features_legacy.f90, and it is not executed. pause would
! wait for stdin, and gfortran 15 does not terminate the real do.

program deleted_features
  implicit none (type, external)

  real :: x
  integer :: lab, i, j, k

  x = -1.0
  assign 20 to lab
  if (x) 10, 20, 30
10 continue
20 continue
30 continue
  go to lab (10, 20, 30)
  pause
  do x = 1.0, 2.0
    k = 0
  end do

  k = 0
  do 40 i = 1, 2
  do 40 j = 1, 2
    k = k + 1
40 continue

end program deleted_features
