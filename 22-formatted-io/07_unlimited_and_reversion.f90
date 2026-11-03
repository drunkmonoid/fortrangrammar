! -----------------------------------------------------------------------------
! 07_unlimited_and_reversion.f90 - more items than descriptors
!
! Run:  scripts/run.sh 22-formatted-io/07_unlimited_and_reversion.f90
! -----------------------------------------------------------------------------
!
! FORMAT REVERSION: when the format runs out of data descriptors but items
! remain, a NEW RECORD is started and processing resumes at the
! last top-level parenthesised group (with its repeat count), or at the
! start of the whole format if it has no such group.
!
!   '(3i4)'                 7 items: rows of three, three, one
!   '("n=", i0, /, (3i4))'  the header is used once, then (3i4) repeats
!
! UNLIMITED REPEAT *(...) (F2008) repeats a group as often as needed on
! the SAME record - the modern way to print a whole array on one line.
! Combine with : to avoid a trailing separator.
!
! Output stops at the first data descriptor with no item left; literal text
! before it is still printed (hence the : trick).

program unlimited_and_reversion
  implicit none (type, external)

  integer :: v(7) = [1, 2, 3, 4, 5, 6, 7]

  print '(a)', 'reversion to the whole format (new record each time):'
  print '(3i4)', v
  print '(a)', 'reversion to the last group (i0 header once):'
  print '("n=", i0, /, (3i4))', size(v), v
  print '(a)', 'unlimited repeat on one line:'
  print '(*(i4))', v
  print '(a)', 'comma-separated with colon:'
  print '(*(i0, :, ","))', v

end program unlimited_and_reversion

! Output:
! reversion to the whole format (new record each time):
!    1   2   3
!    4   5   6
!    7
! reversion to the last group (i0 header once):
! n=7
!    1   2   3
!    4   5   6
!    7
! unlimited repeat on one line:
!    1   2   3   4   5   6   7
! comma-separated with colon:
! 1,2,3,4,5,6,7
