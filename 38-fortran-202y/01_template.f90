! @build skip gfortran 15.2 has no Fortran 2028 templates (J3/26-007r1, J3/26-158)
! -----------------------------------------------------------------------------
! 01_template.f90 - a requirement, a template, and an inline templated subroutine
!
! Run:  scripts/run.sh 38-fortran-202y/01_template.f90
! -----------------------------------------------------------------------------
!
! Syntax follows the Fortran 2028 working draft J3/26-007r1 (3 March 2026),
! clause 16, with J3/26-158: a deferred or instantiation argument list is
! written in braces, and an ordinary dummy argument list stays in
! parentheses. gfortran 15.2 rejects the file, so it is not part of the
! output check. The values this program is written to print are
! total = 5 and swapped = 2 1.

module add_m
  implicit none

  ! The requirement is the constraint on the deferred arguments. The
  ! interface is deferred too: the instantiation supplies the function.
  requirement has_plus {t, plus}
    deferred type :: t
    deferred interface
      function plus(x, y) result(z)
        type(t), intent(in) :: x, y
        type(t) :: z
      end function
    end interface
  end requirement

  template adder {t, plus}
    require has_plus {t, plus}
  contains
    subroutine add(x, y, z)
      type(t), intent(in) :: x, y
      type(t), intent(out) :: z
      z = plus(x, y)
    end subroutine add
  end template

contains

  integer function plus_int(x, y) result(z)
    integer, intent(in) :: x, y
    z = x + y
  end function plus_int

  ! A templated subprogram is not inside a template construct. The
  ! deferred argument list is still braces; (x, y) are ordinary dummies.
  template subroutine swap{u} (x, y)
    deferred type :: u
    type(u), intent(inout) :: x, y
    type(u) :: tmp
    tmp = x
    x = y
    y = tmp
  end subroutine swap

end module add_m

program template_add
  use add_m
  implicit none (type, external)

  integer :: total, a, b

  ! Keyword instantiation arguments, then ONLY to bring one name out.
  instantiate :: adder {t = integer, plus = plus_int}, only: add
  call add(2, 3, total)
  print '(a, i0)', 'total = ', total

  a = 1
  b = 2
  call swap{integer}(a, b)
  print '(a, *(i0, 1x))', 'swapped = ', a, b

end program template_add
