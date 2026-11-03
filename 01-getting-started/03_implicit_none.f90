! -----------------------------------------------------------------------------
! 03_implicit_none.f90 - the three forms of IMPLICIT NONE
!
! Run:  scripts/run.sh 01-getting-started/03_implicit_none.f90
! -----------------------------------------------------------------------------
!
!   implicit none                   every variable must have a declared type
!   implicit none (type)            same thing, spelled out (F2018)
!   implicit none (type, external)  also: every external procedure must be
!                                   declared, with an interface or the
!                                   EXTERNAL attribute (F2018)
!   implicit none (external)        only the procedure rule
!
! IMPLICIT NONE applies to the scoping unit where it appears and to the
! scopes nested inside it (internal procedures, BLOCK constructs).
!
! Interface bodies are the exception: an interface body is its own scoping
! unit and does NOT inherit the host's implicit rules, which is why the
! interface below repeats IMPLICIT NONE.
!
! Modern style: write `implicit none (type, external)` in every program and
! module. Inside a module it covers all module procedures automatically.

program implicit_none_demo
  implicit none (type, external)

  ! With (external), calling shout() without this interface is a compile
  ! error. See 05_implicit_none_external_error.f90.
  interface
    subroutine shout(msg)
      implicit none
      character(len=*), intent(in) :: msg
    end subroutine shout
  end interface

  real :: radius

  radius = 2.0
  print '(a, f0.3)', 'area = ', 3.14159 * radius**2
  call shout('external procedures are now type-checked through the interface')

end program implicit_none_demo

! An external subprogram: it lives outside every other program unit. The
! program above only knows about it through the interface block.
! Modern code puts procedures in modules instead (chapter 14), which makes
! interface blocks like the one above unnecessary.
subroutine shout(msg)
  implicit none (type, external)
  character(len=*), intent(in) :: msg

  print '(a)', msg
end subroutine shout

! Output:
! area = 12.566
! external procedures are now type-checked through the interface
