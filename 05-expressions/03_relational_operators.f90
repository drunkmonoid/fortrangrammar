! -----------------------------------------------------------------------------
! 03_relational_operators.f90 - comparisons
!
! Run:  scripts/run.sh 05-expressions/03_relational_operators.f90
! -----------------------------------------------------------------------------
!
!   ==  /=  <   <=  >   >=        modern spelling
!   .eq. .ne. .lt. .le. .gt. .ge.  equivalent older spelling (still standard)
!
! Results are default LOGICAL. Rules:
!   * Numeric operands are converted as in mixed-mode arithmetic first.
!   * COMPLEX supports only == and /=.
!   * LOGICAL values are compared with .eqv. / .neqv., not ==.
!   * CHARACTER compares in the collating sequence of the processor; the
!     shorter operand is padded with BLANKS, so 'abc' == 'abc   '.
!     For guaranteed ASCII order use lge/lgt/lle/llt (chapter 10).
!   * Comparing reals for exact equality is usually wrong; compare the
!     difference against a tolerance scaled to the magnitude.
!   * Relational operators do not chain: a < b < c is a syntax error.

program relational_operators
  use, intrinsic :: iso_fortran_env, only: dp => real64
  implicit none (type, external)

  real(dp) :: a, b
  integer :: n

  n = 5
  print '(a, 6(1x, l1))', '5 vs 3: == /= < <= > >= :', &
      n == 3, n /= 3, n < 3, n <= 3, n > 3, n >= 3
  print '(a, 2(1x, l1))', 'old spellings .eq. .gt.  :', n .eq. 5, n .gt. 4

  ! Floating point: 0.1 + 0.2 is not exactly 0.3.
  a = 0.1_dp + 0.2_dp
  b = 0.3_dp
  print '(a, l1)', '0.1 + 0.2 == 0.3          : ', a == b
  print '(a, l1)', 'abs(a-b) <= 4*eps*|b|     : ', abs(a - b) <= 4 * epsilon(b) * abs(b)

  ! Character comparison pads with blanks.
  print '(a, l1)', "'abc' == 'abc   '         : ", 'abc' == 'abc   '
  print '(a, l1)', "'abc' <  'abd'            : ", 'abc' < 'abd'
  print '(a, l1)', "'Z' < 'a' (ASCII)         : ", lgt('a', 'Z')

  ! Complex: only equality.
  print '(a, l1)', '(1,2) == (1,2)            : ', (1.0, 2.0) == (1.0, 2.0)

  ! Chaining must be spelled out.
  print '(a, l1)', '1 < n .and. n < 10        : ', 1 < n .and. n < 10

end program relational_operators

! Output:
! 5 vs 3: == /= < <= > >= : F T F F T T
! old spellings .eq. .gt.  : T T
! 0.1 + 0.2 == 0.3          : F
! abs(a-b) <= 4*eps*|b|     : T
! 'abc' == 'abc   '         : T
! 'abc' <  'abd'            : T
! 'Z' < 'a' (ASCII)         : T
! (1,2) == (1,2)            : T
! 1 < n .and. n < 10        : T
