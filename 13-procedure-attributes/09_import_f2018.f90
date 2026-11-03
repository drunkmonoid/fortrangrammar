! @build skip F2018 import, only/none/all are not implemented in gfortran 15
! -----------------------------------------------------------------------------
! 09_import_f2018.f90 - IMPORT, ONLY / NONE / ALL (F2018)
!
! Run:  needs a compiler with the F2018 IMPORT forms
! -----------------------------------------------------------------------------
!
!   import, only: a, b     ONLY these host names are accessible - all other
!                          host names are hidden (stricter than import :: a)
!   import, none           NO host names are accessible
!   import, all            ALL host names are accessible, and none may be
!                          redeclared locally
!
! F2018 also allows IMPORT statements in CONTAINED subprograms and BLOCK
! constructs, to restrict host association there:
!
!   block
!     import, none          ! this block cannot touch outer variables
!     ...
!   end block

module import_forms
  use, intrinsic :: iso_fortran_env, only: real64
  implicit none (type, external)
  integer, parameter :: wp = real64
  real(wp) :: global_state = 0

  interface
    subroutine uses_kind(x)
      import, only: wp
      real(wp), intent(inout) :: x
    end subroutine uses_kind

    subroutine self_contained(n)
      import, none
      integer, intent(in) :: n
    end subroutine self_contained
  end interface

contains

  subroutine isolated_block()
    integer :: outer
    outer = 1
    block
      import, none                       ! `outer` and `global_state` hidden
      integer :: inner
      inner = 2
      print *, inner
    end block
    print *, outer
  end subroutine isolated_block

end module import_forms

program import_f2018
  use import_forms, only: isolated_block
  implicit none (type, external)
  call isolated_block()
end program import_f2018
