! @flags -std=legacy
! @run no
! -----------------------------------------------------------------------------
! 02_deleted_features_legacy.f90 - the deleted forms, accepted by -std=legacy
!
! Compile only: scripts/check_all.sh 34-deleted-features
! -----------------------------------------------------------------------------
!
! -std=legacy is placed after the default -std=f2023, so it wins. @run no
! keeps check_all from executing the program: pause waits for stdin, and
! on gfortran 15 the real do-variable does not reach its limit.
!
! This is the same program as 01_deleted_features.f90.

program deleted_features_legacy
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

end program deleted_features_legacy
