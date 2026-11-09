! -----------------------------------------------------------------------------
! 02_common_mismatch.f90 - a COMMON block whose units disagree
!
! Run:  scripts/run.sh 32-storage-association/02_common_mismatch.f90
! -----------------------------------------------------------------------------
!
! produce stores two integers. consume declares one integer in the same
! block, so its m occupies the storage of produce's n. The value 5 is
! still there; consume has no name for it.
!
! The program is not conforming. gfortran 15 warns that /buf/ is 8 bytes
! in one unit and 4 in the other, then links it anyway. A module would
! have made this a compile error.

program common_mismatch
  implicit none (type, external)

  interface
    subroutine produce
    end subroutine produce
    subroutine consume
    end subroutine consume
  end interface

  call produce
  call consume

end program common_mismatch

subroutine produce
  implicit none (type, external)
  integer :: n, m
  common /buf/ n, m

  n = 2
  m = 5
end subroutine produce

subroutine consume
  implicit none (type, external)
  integer :: m
  common /buf/ m

  print '(a, i0)', 'shifted m = ', m
end subroutine consume

! Output:
! shifted m = 2
