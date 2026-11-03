! -----------------------------------------------------------------------------
! 05_finalization.f90 - FINAL procedures (destructors)
!
! Run:  scripts/run.sh 19-oop-advanced/05_finalization.f90
! -----------------------------------------------------------------------------
!
!   type :: resource
!   contains
!     final :: release              ! subroutine with ONE dummy: type(resource)
!   end type
!
! A final subroutine runs automatically when an object of that type stops
! existing or is overwritten:
!   * DEALLOCATE of an allocatable / pointer object;
!   * a non-saved local variable when its procedure or BLOCK ends;
!   * the LHS of intrinsic assignment, before it is overwritten;
!   * an intent(out) actual argument, on procedure entry;
!   * a function result after the expression using it is evaluated.
! NOT finalized: variables of the main program and module variables when
! the program ends (they are implicitly saved). Test finalizers in a BLOCK.
!
! * The dummy is type(t), NOT class(t), and is intent(inout).
! * Separate final subroutines can be given per rank (or one elemental).
! * Order for extended types: the child's final runs first, then the
!   parent's (the parent part is finalized after the child's).
! * Allocatable components are deallocated automatically anyway; finalizers
!   are for other resources: files, external library handles, pointers,
!   logging.

module resources
  implicit none (type, external)
  private
  public :: resource, tracked

  type :: resource
    character(len=8) :: name = '?'
  contains
    final :: release, release_array
  end type resource

  type, extends(resource) :: tracked
  contains
    final :: untrack
  end type tracked

contains

  subroutine release(self)
    type(resource), intent(inout) :: self
    print '(3a)', '  final(resource) for "', trim(self%name), '"'
  end subroutine release

  subroutine release_array(self)
    type(resource), intent(inout) :: self(:)
    print '(a, i0, a)', '  final(resource array) for ', size(self), ' elements'
  end subroutine release_array

  subroutine untrack(self)
    type(tracked), intent(inout) :: self
    print '(3a)', '  final(tracked) for "', trim(self%name), '"'
  end subroutine untrack

end module resources

program finalization
  use resources, only: resource, tracked
  implicit none (type, external)

  type(resource), allocatable :: heap
  type(resource), allocatable :: many(:)

  print '(a)', '1. end of a BLOCK:'
  block
    type(resource) :: local
    local%name = 'local'
  end block

  print '(a)', '2. deallocate:'
  allocate (heap)
  heap%name = 'heap'
  deallocate (heap)

  print '(a)', '3. assignment finalizes the old value of the LHS:'
  block
    type(resource) :: r
    r%name = 'old'
    print '(a)', '  (assigning)'
    r = resource('new')
    print '(a)', '  (end of block)'
  end block

  print '(a)', '4. extended type: child final, then parent final:'
  block
    type(tracked) :: t
    t%name = 'tracked'
  end block

  print '(a)', '5. arrays use the rank-1 final procedure:'
  allocate (many(3))
  deallocate (many)

  print '(a)', 'end of program (main-program variables are not finalized)'

end program finalization

! Output:
! 1. end of a BLOCK:
!   final(resource) for "local"
! 2. deallocate:
!   final(resource) for "heap"
! 3. assignment finalizes the old value of the LHS:
!   (assigning)
!   final(resource) for "old"
!   (end of block)
!   final(resource) for "new"
! 4. extended type: child final, then parent final:
!   final(tracked) for "tracked"
!   final(resource) for "tracked"
! 5. arrays use the rank-1 final procedure:
!   final(resource array) for 3 elements
! end of program (main-program variables are not finalized)
