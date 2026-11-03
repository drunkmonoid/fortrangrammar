! -----------------------------------------------------------------------------
! 05_pointer_vs_allocatable.f90 - choosing between them
!
! Run:  scripts/run.sh 21-pointers/05_pointer_vs_allocatable.f90
! -----------------------------------------------------------------------------
!
!                         allocatable              pointer
!   ------------------    ---------------------    -------------------------
!   owns its storage      always                   maybe (allocate) or alias
!   automatic free        yes (scope end, intent   never
!                         out, component of freed
!                         object)
!   assignment a = b      deep copy, realloc       copies VALUES into the
!                                                  target (shapes must match)
!   component copy        deep                     shallow (shares target)
!   can alias other data  no                       yes - its whole purpose
!   non-contiguous view   no                       yes (sections, remapping)
!   cycles / sharing      no                       yes
!   optimisation          compiler knows no alias  must assume aliasing
!   status inquiry        allocated()              associated()
!
! Rule of thumb: allocatable for dynamic data, pointer for views and
! linked structures. A pointer that should OWN data is usually better as an
! allocatable plus a `target` attribute where views are needed.

program pointer_vs_allocatable
  implicit none (type, external)

  type :: with_alloc
    integer, allocatable :: data(:)
  end type with_alloc

  type :: with_ptr
    integer, pointer :: data(:) => null()
  end type with_ptr

  type(with_alloc) :: a1, a2
  type(with_ptr) :: p1, p2

  a1%data = [1, 2, 3]
  a2 = a1                       ! deep copy
  a2%data(1) = 99
  print '(a, 3(1x, i0), a, 3(1x, i0))', 'allocatable: a1 =', a1%data, '  a2 =', a2%data

  allocate (p1%data(3), source=[1, 2, 3])
  p2 = p1                       ! shallow: both point at the same storage
  p2%data(1) = 99
  print '(a, 3(1x, i0), a, 3(1x, i0))', 'pointer    : p1 =', p1%data, '  p2 =', p2%data

  deallocate (p1%data)          ! p2%data is now dangling...
  nullify (p2%data)             ! ...so forget it explicitly

end program pointer_vs_allocatable

! Output:
! allocatable: a1 = 1 2 3  a2 = 99 2 3
! pointer    : p1 = 99 2 3  p2 = 99 2 3
