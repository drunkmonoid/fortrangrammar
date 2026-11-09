! -----------------------------------------------------------------------------
! 01_statement_functions.f90 - one-line functions in the specification part
!
! Run:  scripts/run.sh 33-obsolescent-forms/01_statement_functions.f90
! -----------------------------------------------------------------------------
!
!   square(n) = n * n
!
! The name is declared with the result type. The names in parentheses are
! the dummies; they are scalars already declared in the host, and inside
! the statement they mean the dummies. The statement function must appear
! before the first executable statement of the program unit.
!
! An internal function after contains (chapter 11) is the replacement. It
! can be more than one line, and it can be pure.

program statement_functions
  implicit none (type, external)

  integer :: square, n
  real :: hypotenuse, x, y
  square(n) = n * n
  hypotenuse(x, y) = sqrt(x * x + y * y)

  print '(a, i0)', 'square(5) = ', square(5)
  print '(a, f3.1)', 'hypotenuse(3, 4) = ', hypotenuse(3.0, 4.0)
  print '(a, i0)', 'internal square(5) = ', internal_square(5)

contains

  integer function internal_square(k) result(s)
    integer, intent(in) :: k
    s = k * k
  end function internal_square

end program statement_functions

! Output:
! square(5) = 25
! hypotenuse(3, 4) = 5.0
! internal square(5) = 25
