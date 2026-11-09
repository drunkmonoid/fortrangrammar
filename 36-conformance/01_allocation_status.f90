! -----------------------------------------------------------------------------
! 01_allocation_status.f90 - allocated() before any reference
!
! Run:  scripts/run.sh 36-conformance/01_allocation_status.f90
! -----------------------------------------------------------------------------
!
! An allocatable that has not been allocated has no elements and no
! bounds. allocated() is the test. Referencing it anyway is not a
! conforming program; 02_unallocated_reference.f90 is that reference,
! and check_all does not run it.

program allocation_status
  implicit none (type, external)

  integer, allocatable :: a(:)

  print '(a, l1)', 'before: ', allocated(a)
  allocate (a(2))
  a = [4, 5]
  print '(a, l1)', 'after: ', allocated(a)
  print '(a, 2(1x, i0))', 'a =', a

end program allocation_status

! Output:
! before: F
! after: T
! a = 4 5
