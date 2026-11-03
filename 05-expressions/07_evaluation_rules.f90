! -----------------------------------------------------------------------------
! 07_evaluation_rules.f90 - what the compiler may and may not reorder
!
! Run:  scripts/run.sh 05-expressions/07_evaluation_rules.f90
! -----------------------------------------------------------------------------
!
! The processor may evaluate any expression that is MATHEMATICALLY
! equivalent to the one you wrote, provided that:
!   * parentheses are honoured: (a + b) + c is never turned into a + (b + c);
!   * integer division is not "simplified" (i/2*2 is not i);
!   * operands are evaluated in any order (no left-to-right guarantee);
!   * a function reference need not be evaluated if its value is not
!     needed - another reason for side-effect-free functions.
!
! Consequence: for floating point, `x + y - y` may or may not equal x,
! but `(x + y) - y` is computed exactly as written. (Unless you compile with
! -ffast-math / -Ofast, which deliberately break these guarantees.)
!
! Also: an expression must not reference a variable that a function in the
! same statement modifies (the result would be processor dependent).

program evaluation_rules
  use, intrinsic :: iso_fortran_env, only: dp => real64
  implicit none (type, external)

  real(dp) :: big, small
  integer :: i

  big = 1.0e20_dp
  small = 1.0_dp

  ! Parentheses force the order: small is lost when added to big first.
  print '(a, f0.1)', '(small + big) - big = ', (small + big) - big
  print '(a, f0.1)', 'small + (big - big) = ', small + (big - big)

  ! Integer division is never algebraically simplified.
  i = 7
  print '(a, i0)', 'i / 2 * 2           = ', i / 2 * 2
  print '(a, i0)', 'i * 2 / 2           = ', i * 2 / 2

end program evaluation_rules

! Output:
! (small + big) - big = .0
! small + (big - big) = 1.0
! i / 2 * 2           = 6
! i * 2 / 2           = 7
