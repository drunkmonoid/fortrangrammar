! -----------------------------------------------------------------------------
! 02_entry.f90 - ENTRY: several procedure names, one body
!
! Run:  scripts/run.sh 33-obsolescent-forms/02_entry.f90
! -----------------------------------------------------------------------------
!
!   entry get_value(m)
!
! Calling set_value enters at the top. Calling get_value enters at the
! entry statement. They share the save variable. Every dummy of every
! entry is declared in the specification part, before any executable
! statement, and the interface for each name has to match, intent included.
!
! entry is not allowed in a module or internal procedure. The replacement
! is two module procedures that share a private module variable.

program entry_demo
  implicit none (type, external)

  interface
    subroutine set_value(n)
      integer, intent(in) :: n
    end subroutine set_value
    subroutine get_value(m)
      integer, intent(out) :: m
    end subroutine get_value
  end interface

  integer :: a, b

  call set_value(3)
  call get_value(a)
  call set_value(9)
  call get_value(b)
  print '(a, i0, a, i0)', 'first = ', a, ', second = ', b

end program entry_demo

subroutine set_value(n)
  implicit none (type, external)
  integer, intent(in) :: n
  integer, intent(out) :: m
  integer, save :: saved

  saved = n
  return

entry get_value(m)
  m = saved
end subroutine set_value

! Output:
! first = 3, second = 9
