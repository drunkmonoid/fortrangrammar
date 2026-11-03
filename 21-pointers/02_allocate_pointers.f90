! -----------------------------------------------------------------------------
! 02_allocate_pointers.f90 - pointers to anonymous storage; leaks, dangling
!
! Run:  scripts/run.sh 21-pointers/02_allocate_pointers.f90
! -----------------------------------------------------------------------------
!
!   allocate (p)          creates an unnamed target and points p at it
!   deallocate (p)        frees it; p becomes disassociated
!
! Unlike allocatables, nothing frees pointer targets automatically:
!
!   * LEAK: re-pointing or losing the only pointer to allocated storage
!       allocate (p); p => other            ! the first target is lost
!   * DANGLING POINTER: another pointer to storage that was deallocated, or
!     to a local TARGET of a procedure that has returned, is UNDEFINED.
!     Using it is undefined behaviour; associated() cannot detect it.
!       allocate (p); q => p; deallocate (p)   ! q is now dangling
!   * Only deallocate through a pointer that points at the WHOLE allocated
!     object (not a section of it, not a non-allocated target).
!
! These are exactly the bugs allocatables make impossible - so use
! pointers only when you need aliasing or linked structures.

program allocate_pointers
  implicit none (type, external)

  integer, pointer :: p => null(), q => null()
  integer, pointer :: arr(:) => null()

  allocate (p)
  p = 42
  print '(a, i0)', 'allocated scalar: ', p

  q => p                          ! alias of the same anonymous target
  q = 43
  print '(a, i0)', 'changed via q   : ', p

  deallocate (p)                  ! p is disassociated now...
  print '(a, l1)', 'associated(p)   : ', associated(p)
  q => null()                     ! ...and q would be DANGLING: reset it too

  allocate (arr(5), source=7)
  print '(a, *(1x, i0))', 'allocated array :', arr
  deallocate (arr)

  ! A leak, deliberately: the first allocation is unreachable afterwards.
  ! (Tools like valgrind or -fsanitize=address report it; chapter 30.)
  allocate (p)
  allocate (p)
  deallocate (p)
  print '(a)', 'one integer leaked on purpose'

end program allocate_pointers

! Output:
! allocated scalar: 42
! changed via q   : 43
! associated(p)   : F
! allocated array : 7 7 7 7 7
! one integer leaked on purpose
