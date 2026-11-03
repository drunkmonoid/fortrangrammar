! -----------------------------------------------------------------------------
! 05_module_state.f90 - module variables as program-wide state
!
! Run:  scripts/run.sh 14-modules/05_module_state.f90
! -----------------------------------------------------------------------------
!
! Module variables exist once for the whole program and keep their values
! (they are implicitly SAVE since F2008). That makes them the modern
! replacement for COMMON blocks - and also makes them GLOBAL STATE, with all
! the usual problems: hidden coupling, no thread safety, hard testing.
!
! Guidelines:
!   * keep state private and expose procedures (or PROTECTED variables);
!   * provide an explicit initialise/finalise pair when setup is needed;
!   * prefer passing a derived-type "context" object for anything that could
!     ever need two instances.
! The example contrasts a module-level counter with an object.

module id_generator
  implicit none (type, external)
  private
  public :: next_id, reset_ids, id_source

  integer :: last_id = 0                 ! global, single instance

  type :: id_source                      ! the same idea as an object
    integer :: last = 0
  contains
    procedure :: next => source_next
  end type id_source

contains

  integer function next_id()
    last_id = last_id + 1
    next_id = last_id
  end function next_id

  subroutine reset_ids()
    last_id = 0
  end subroutine reset_ids

  integer function source_next(self)
    class(id_source), intent(inout) :: self
    self%last = self%last + 1
    source_next = self%last
  end function source_next

end module id_generator

program module_state
  use id_generator, only: next_id, reset_ids, id_source
  implicit none (type, external)

  type(id_source) :: users, orders
  integer :: a, b, c

  a = next_id(); b = next_id(); c = next_id()
  print '(a, 3(1x, i0))', 'global ids:', a, b, c
  call reset_ids()
  a = next_id()
  print '(a, i0)', 'after reset: ', a

  a = users%next(); b = users%next(); c = orders%next()
  print '(a, i0, 1x, i0, a, i0)', 'independent sources: users ', a, b, ', orders ', c

end program module_state

! Output:
! global ids: 1 2 3
! after reset: 1
! independent sources: users 1 2, orders 1
