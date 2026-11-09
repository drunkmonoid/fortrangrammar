! -----------------------------------------------------------------------------
! 01_checksum.f90 - do concurrent fill and reduce, checked by a sum
!
! Run:  scripts/run.sh 63-do-concurrent-performance/01_checksum.f90
! -----------------------------------------------------------------------------
!
! The fill writes a(i) only, so the iterations are independent.
! The sum uses reduce(+: s). Inside that loop s may appear only as
! `s = s + expr` (chapter 28).
!
! This is the form that is not a reduction and must not be parallelised:
!
!   s = 0
!   do concurrent (i = 1:4)
!     s = s + a(i)
!   end do
!
! -ftree-parallelize-loops=N asks gfortran to parallelise do concurrent.
! It is allowed to decline. Either way the checksum is 30.

program concurrent_checksum
  implicit none (type, external)

  integer :: a(4), i, s

  do concurrent (i = 1:4)
    a(i) = i * i
  end do

  s = 0
  do concurrent (i = 1:4) reduce(+: s)
    s = s + a(i)
  end do

  print '(a, i0)', 'checksum = ', s

end program concurrent_checksum

! Output:
! checksum = 30
