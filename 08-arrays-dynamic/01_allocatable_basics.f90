! -----------------------------------------------------------------------------
! 01_allocatable_basics.f90 - ALLOCATABLE arrays
!
! Run:  scripts/run.sh 08-arrays-dynamic/01_allocatable_basics.f90
! -----------------------------------------------------------------------------
!
!   real, allocatable :: a(:), m(:, :)       deferred shape: rank only
!   allocate (a(n), m(0:n, 3) [, stat=s] [, errmsg=msg])
!   deallocate (a, m [, stat=s] [, errmsg=msg])
!   allocated(a)                             .true. if currently allocated
!
! * Allocatables start unallocated. Using one before allocating it is an
!   error (caught by -fcheck=all).
! * Allocating an already-allocated array is an error; with stat= it gives
!   a nonzero status instead of aborting. Same for deallocating twice.
! * A local allocatable WITHOUT save is deallocated automatically when the
!   procedure (or BLOCK) ends - no leaks, no free() needed.
! * Prefer allocatable over pointer whenever you just need dynamic size:
!   allocatables cannot leak, cannot alias, and optimise better.

program allocatable_basics
  implicit none (type, external)

  real, allocatable :: a(:)
  integer, allocatable :: m(:, :)
  integer :: n, stat
  character(len=200) :: msg

  print '(a, l1)', 'allocated before: ', allocated(a)

  n = 5
  allocate (a(n))
  a = 1.5
  print '(a, l1, a, i0)', 'allocated after : ', allocated(a), ', size = ', size(a)

  ! Custom bounds.
  allocate (m(0:2, -1:1))
  m = 7
  print '(a, *(1x, i0))', 'lbound(m):', lbound(m)
  print '(a, *(1x, i0))', 'ubound(m):', ubound(m)

  ! Allocating twice: an error. With stat= we can handle it.
  allocate (a(10), stat=stat, errmsg=msg)
  if (stat /= 0) print '(a, i0, 2a)', 'second allocate failed, stat = ', stat, ': ', trim(msg)

  ! Re-size: deallocate first.
  deallocate (a)
  allocate (a(10))
  print '(a, i0)', 'resized to ', size(a)

  deallocate (a, m)
  print '(a, l1)', 'allocated after deallocate: ', allocated(a)

  ! Deallocating an unallocated array: also an error, also catchable.
  deallocate (a, stat=stat, errmsg=msg)
  if (stat /= 0) print '(a, i0, 2a)', 'double deallocate, stat = ', stat, ': ', trim(msg)

  call uses_scratch(1000)

contains

  subroutine uses_scratch(size_needed)
    integer, intent(in) :: size_needed
    real, allocatable :: scratch(:)

    allocate (scratch(size_needed))
    scratch = 0
    print '(a, i0, a)', 'scratch of ', size(scratch), ' elements, freed automatically at return'
  end subroutine uses_scratch

end program allocatable_basics

! Output:
! allocated before: F
! allocated after : T, size = 5
! lbound(m): 0 -1
! ubound(m): 2 1
! second allocate failed, stat = 5014: Attempt to allocate an allocated object
! resized to 10
! allocated after deallocate: F
! double deallocate, stat = 1: Attempt to deallocate an unallocated object
! scratch of 1000 elements, freed automatically at return
