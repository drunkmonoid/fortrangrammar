! -----------------------------------------------------------------------------
! 04_no_short_circuit.f90 - logical operators do NOT promise short-circuiting
!
! Run:  scripts/run.sh 05-expressions/04_no_short_circuit.f90
! -----------------------------------------------------------------------------
!
! In `a .and. b` the processor may evaluate a first, b first, both, or only
! what it needs. The standard only says the result must be right. So
!
!     if (i <= size(x) .and. x(i) > 0) ...       ! WRONG
!     if (present(opt) .and. opt > 0) ...        ! WRONG
!     if (associated(p) .and. p%val == 1) ...    ! WRONG
!
! may evaluate x(i) out of bounds, touch an absent argument or dereference a
! null pointer. gfortran often short-circuits in practice, which hides the
! bug until another compiler or optimisation level exposes it.
!
! Safe patterns:
!   1. Nested IF constructs.
!   2. F2023 conditional expression  ( cond ? a : b ), which IS guaranteed to
!      evaluate only the selected branch (see 08_conditional_expressions.f90).
!   3. NOT merge(): merge evaluates all its arguments.
!
! Also: a function with side effects in a logical expression may or may
! not be called. Keep functions used in expressions free of side effects.

program no_short_circuit
  implicit none (type, external)

  integer :: values(3) = [5, -1, 7]
  integer :: i

  do i = 1, 4
    ! Pattern 1: nested IF - x(i) is only touched when i is in range.
    if (i <= size(values)) then
      if (values(i) > 0) then
        print '(a, i0, a)', 'values(', i, ') is positive'
        cycle
      end if
    end if
    print '(a, i0, a)', 'index ', i, ' is out of range or not positive'
  end do

  call report()
  call report(3)

contains

  subroutine report(level)
    integer, intent(in), optional :: level

    ! WRONG: if (present(level) .and. level > 2) ...
    if (present(level)) then
      if (level > 2) then
        print '(a, i0)', 'verbose report, level ', level
        return
      end if
    end if
    print '(a)', 'short report'
  end subroutine report

end program no_short_circuit
