! -----------------------------------------------------------------------------
! 03_alternate_return.f90 - CALL with label arguments, RETURN n
!
! Run:  scripts/run.sh 33-obsolescent-forms/03_alternate_return.f90
! -----------------------------------------------------------------------------
!
!   call check(code, *10, *20)
!   return 1          ! branch to the first label in that call
!
! The * dummies are not values. return 1 leaves through the first
! alternate, return 2 through the second, and a plain return comes back
! to the statement after the call. The interface writes * in those
! positions, because implicit none (external) requires an explicit
! interface for the external subroutine.
!
! An integer status does the same job and can be used in an expression.

program alternate_return_demo
  implicit none (type, external)

  interface
    subroutine check(code, *, *)
      integer, intent(in) :: code
    end subroutine check
  end interface

  call check(1, *10, *20)
  print '(a)', 'alternate: normal'
  stop

10 print '(a)', 'alternate: branch 1'
  print '(a)', 'status: ' // status_name(classify(1))
  stop

20 print '(a)', 'alternate: branch 2'
  stop

contains

  integer function classify(code) result(which)
    integer, intent(in) :: code
    if (code == 1) then
      which = 1
    else if (code == 2) then
      which = 2
    else
      which = 0
    end if
  end function classify

  function status_name(which) result(name)
    integer, intent(in) :: which
    character(len=8) :: name
    select case (which)
    case (1)
      name = 'branch 1'
    case (2)
      name = 'branch 2'
    case default
      name = 'normal'
    end select
  end function status_name

end program alternate_return_demo

subroutine check(code, *, *)
  implicit none (type, external)
  integer, intent(in) :: code

  if (code == 1) return 1
  if (code == 2) return 2
end subroutine check

! Output:
! alternate: branch 1
! status: branch 1
