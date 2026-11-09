! @run no
! -----------------------------------------------------------------------------
! 02_unallocated_reference.f90 - using an allocatable that was never allocated
!
! Compile only: scripts/check_all.sh 36-conformance
! -----------------------------------------------------------------------------
!
! The standard gives this program no meaning. gfortran 15 still compiles
! it. Running it under -fcheck=all does not produce the tidy "index out
! of bounds" error from chapter 30: the bounds live in a descriptor that
! was never initialised, so the check itself segfaults (exit status 139
! on this machine). That status is not something to depend on, which is
! why this file is @run no.
!
! Test with allocated() first (01_allocation_status.f90).

program unallocated_reference
  implicit none (type, external)

  integer, allocatable :: a(:)

  print '(i0)', a(1)

end program unallocated_reference
