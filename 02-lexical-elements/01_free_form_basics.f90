! -----------------------------------------------------------------------------
! 01_free_form_basics.f90 - lines, statements, case and blanks
!
! Run:  scripts/run.sh 02-lexical-elements/01_free_form_basics.f90
! -----------------------------------------------------------------------------
!
! Free source form rules (the only form used in this tutorial):
!
!   * A statement may start in any column.
!   * A line holds at most 10 000 characters (F2023; was 132 before).
!     gfortran still defaults to 132 - use -ffree-line-length-none if needed.
!   * A statement may be at most 1 000 000 characters including continuations.
!   * Several statements can share a line, separated by `;`.
!   * Letters are case-insensitive everywhere except inside character literals.
!   * Blanks are significant: they separate tokens and may not appear inside
!     a name, keyword, literal constant or operator - with the "optional
!     blank" exceptions shown in 08_optional_blanks.f90.

program free_form_basics
  implicit none (type, external)

  integer :: counter
  real :: Total, total_squared   ! "Total" and "total" would be the same name!

  ! Case-insensitive: these three statements refer to the same variable.
  counter = 1
  COUNTER = Counter + 1
  CoUnTeR = counter * 10
  print '(a, i0)', 'counter = ', counter

  ! Several statements on one line, separated by semicolons.
  total = 2.0; total_squared = total**2; print '(a, f0.1)', 'squared: ', total_squared

  ! A semicolon at the end of a line is allowed and ignored.
  counter = 0;

  ! Statements can be indented freely.
        print '(a)', 'indentation does not matter'

  ! Case IS significant inside character literals.
  print '(a)', 'Hello' // ' ' // 'HELLO'

  ! A blank line, or a line with only a comment, is not a statement.

end program free_form_basics

! Output:
! counter = 20
! squared: 4.0
! indentation does not matter
! Hello HELLO
