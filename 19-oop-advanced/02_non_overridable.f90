! @build fail
! -----------------------------------------------------------------------------
! 02_non_overridable.f90 - NON_OVERRIDABLE (must not compile)
!
! Try: scripts/run.sh 19-oop-advanced/02_non_overridable.f90
! -----------------------------------------------------------------------------
!
!   procedure, non_overridable :: id
!
! A NON_OVERRIDABLE binding cannot be overridden in any extension. Use it
! for behaviour that must stay fixed (invariants, identity, bookkeeping) and
! to let the compiler call the procedure directly without dispatch.
!
! gfortran reports something like:
!   Error: 'id' at (1) overrides a procedure binding declared NON_OVERRIDABLE

module entities
  implicit none (type, external)

  type :: entity
    integer :: key = 0
  contains
    procedure, non_overridable :: id
  end type entity

  type, extends(entity) :: user
  contains
    procedure :: id => user_id       ! ERROR: id is non_overridable
  end type user

contains

  integer function id(self)
    class(entity), intent(in) :: self
    id = self%key
  end function id

  integer function user_id(self)
    class(user), intent(in) :: self
    user_id = -1
  end function user_id

end module entities

program non_overridable
  use entities, only: user
  implicit none (type, external)
  type(user) :: u
  print *, u%id()
end program non_overridable
