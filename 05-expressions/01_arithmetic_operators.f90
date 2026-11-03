! -----------------------------------------------------------------------------
! 01_arithmetic_operators.f90 - + - * / ** and their rules
!
! Run:  scripts/run.sh 05-expressions/01_arithmetic_operators.f90
! -----------------------------------------------------------------------------
!
!   **        exponentiation      RIGHT-associative: 2**3**2 = 2**9
!   * /       multiply, divide    left-associative
!   + -       add, subtract       left-associative; also unary
!
! Pitfalls:
!   * Unary minus has the precedence of binary minus, LOWER than **:
!     -2**2 is -(2**2) = -4.
!   * Two operators may not be adjacent: x * -y is illegal, write x * (-y).
!   * Integer division truncates toward zero: 7/2 = 3, -7/2 = -3.
!   * integer ** negative integer is integer division: 2**(-1) = 1/2 = 0.
!   * real ** integer is computed by repeated multiplication (exact, fast);
!     prefer x**2 over x**2.0.
!   * A negative REAL base with a REAL exponent is an error: (-8.0)**(1.0/3)
!     has no real result.
!   * mod(a, p) has the sign of a; modulo(a, p) has the sign of p.

program arithmetic_operators
  implicit none (type, external)

  integer :: i
  real :: x

  print '(a, i0)', '2**3**2      = ', 2**3**2
  print '(a, i0)', '(2**3)**2    = ', (2**3)**2
  print '(a, i0)', '-2**2        = ', -2**2
  print '(a, i0)', '(-2)**2      = ', (-2)**2
  print '(a, i0)', '7 / 2        = ', 7 / 2
  print '(a, i0)', '-7 / 2       = ', -7 / 2
  print '(a, i0)', '2**(-1)      = ', 2**(-1)
  print '(a, f0.4)', '2.0**(-1)    = ', 2.0**(-1)
  print '(a, i0)', '10 - 4 - 3   = ', 10 - 4 - 3
  print '(a, i0)', '100 / 10 / 5 = ', 100 / 10 / 5
  print '(a, i0)', '1 + 2 * 3    = ', 1 + 2 * 3

  ! mod vs modulo
  print '(a, i0, 1x, i0)', 'mod(-7, 3), modulo(-7, 3)  = ', mod(-7, 3), modulo(-7, 3)
  print '(a, i0, 1x, i0)', 'mod(7, -3), modulo(7, -3)  = ', mod(7, -3), modulo(7, -3)
  print '(a, f0.2)', 'modulo(5.5, 2.0)           = ', modulo(5.5, 2.0)

  ! Adjacent operators need parentheses.
  x = 3.0
  print '(a, f0.1)', 'x * (-2)     = ', x * (-2)

  ! Real cube root of a negative number: take the root of |x| and restore
  ! the sign; (-8.0)**(1.0/3.0) would be invalid.
  x = -8.0
  print '(a, f0.4)', 'cbrt(-8)     = ', sign(abs(x)**(1.0 / 3.0), x)

  ! Integer exponent: exact; real exponent: via exp(log()).
  i = 3
  print '(a, f0.3, 1x, f0.3)', '1.5**i, 1.5**3.0 = ', 1.5**i, 1.5**3.0

end program arithmetic_operators

! Output:
! 2**3**2      = 512
! (2**3)**2    = 64
! -2**2        = -4
! (-2)**2      = 4
! 7 / 2        = 3
! -7 / 2       = -3
! 2**(-1)      = 0
! 2.0**(-1)    = .5000
! 10 - 4 - 3   = 3
! 100 / 10 / 5 = 2
! 1 + 2 * 3    = 7
! mod(-7, 3), modulo(-7, 3)  = -1 2
! mod(7, -3), modulo(7, -3)  = 1 -2
! modulo(5.5, 2.0)           = 1.50
! x * (-2)     = -6.0
! cbrt(-8)     = -2.0000
! 1.5**i, 1.5**3.0 = 3.375 3.375
