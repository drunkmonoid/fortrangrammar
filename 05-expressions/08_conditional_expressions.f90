! @build skip F2023 conditional expressions are not implemented in gfortran 15
! -----------------------------------------------------------------------------
! 08_conditional_expressions.f90 - F2023 ( cond ? a : b )
!
! Run:  needs a compiler with F2023 conditional expressions
! -----------------------------------------------------------------------------
!
!   ( condition ? expr1 : expr2 )
!   ( c1 ? e1 : c2 ? e2 : e3 )         chained: else-if
!
! Rules:
!   * The PARENTHESES are part of the syntax and are mandatory.
!   * Only the selected expression is evaluated - a guaranteed short
!     circuit, unlike .and./.or. and merge().
!   * All branches must have the same type, kind and rank (character
!     lengths may differ).
!
! Conditional ARGUMENTS (also F2023) choose what is passed to a procedure,
! including `.nil.` to mean "absent" for an optional dummy:
!
!   call f( (present(x) ? x : default_x) )
!   call g( (verbose ? unit_out : .nil.) )

program conditional_expressions
  implicit none (type, external)

  integer :: n, i
  integer :: values(3) = [5, -1, 7]
  character(len=:), allocatable :: label

  n = 7
  label = (mod(n, 2) == 0 ? 'even' : 'odd')
  print '(a, i0, 2a)', 'n = ', n, ' is ', label

  ! Chained conditions.
  label = (n < 0 ? 'negative' : n == 0 ? 'zero' : 'positive')
  print '(2a)', 'sign: ', label

  ! Safe guarded access: values(i) is not evaluated when i is out of range.
  do i = 1, 4
    print '(a, i0, a, l1)', 'positive(', i, ') = ', &
        (i <= size(values) ? values(i) > 0 : .false.)
  end do

  call show()
  call show(42)

contains

  subroutine show(level)
    integer, intent(in), optional :: level

    print '(a, i0)', 'level = ', (present(level) ? level : 1)
  end subroutine show

end program conditional_expressions
