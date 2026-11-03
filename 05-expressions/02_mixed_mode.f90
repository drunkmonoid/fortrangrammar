! -----------------------------------------------------------------------------
! 02_mixed_mode.f90 - expressions that mix types and kinds
!
! Run:  scripts/run.sh 05-expressions/02_mixed_mode.f90
! -----------------------------------------------------------------------------
!
! For a binary numeric operation x1 op x2:
!
!   integer op integer  -> integer   (kind of the larger range)
!   integer op real     -> real      (the integer is converted first)
!   integer op complex  -> complex
!   real    op real     -> real      (kind of the greater precision)
!   real    op complex  -> complex   (greater precision)
!
! The conversion happens per OPERATION, following precedence and
! associativity - not for the expression as a whole. So `1/2 * x` is
! (1/2) * x = 0 * x, even when x is real. This is the most common
! numerical bug after missing literal kind suffixes.
!
! Exception for **: real ** integer keeps the integer as an integer power.

program mixed_mode
  use, intrinsic :: iso_fortran_env, only: sp => real32, dp => real64, int64
  implicit none (type, external)

  real(dp) :: x
  real(sp) :: s
  integer :: n
  integer(int64) :: big

  x = 10.0_dp
  n = 3

  print '(a, f0.4)', '1/2 * x      = ', 1 / 2 * x       ! integer 1/2 first
  print '(a, f0.4)', 'x * 1/2      = ', x * 1 / 2       ! left to right: real
  print '(a, f0.4)', '0.5_dp * x   = ', 0.5_dp * x
  print '(a, f0.4)', 'x / n        = ', x / n           ! n converted to real(dp)
  print '(a, f0.4)', 'n / 2        = ', real(n / 2, dp)
  print '(a, f0.4)', 'real(n)/2    = ', real(n, dp) / 2

  ! Kind of the result: the more precise operand wins.
  s = 1.0_sp
  print '(a, i0)', 'kind(s * x)  = ', kind(s * x)
  print '(a, i0)', 'kind(s * n)  = ', kind(s * n)

  ! Integer kinds: the larger range wins - but only for that operation.
  ! In `big = n * n` with default-kind n, the product is computed in default
  ! kind (and may overflow) BEFORE it is widened by the assignment.
  big = 100000_int64
  print '(a, i0)', 'kind(n * big)= ', kind(n * big)
  print '(a, i0)', 'big * big    = ', big * big

  ! Average of integers: convert before dividing.
  print '(a, f0.4)', 'avg(1,2) wrong = ', real((1 + 2) / 2, dp)
  print '(a, f0.4)', 'avg(1,2) right = ', real(1 + 2, dp) / 2

  ! complex op real
  print '(a, 2(1x, f0.2))', '(1,1) * 2.0_dp =', (1.0_dp, 1.0_dp) * 2.0_dp

end program mixed_mode

! Output:
! 1/2 * x      = .0000
! x * 1/2      = 5.0000
! 0.5_dp * x   = 5.0000
! x / n        = 3.3333
! n / 2        = 1.0000
! real(n)/2    = 1.5000
! kind(s * x)  = 8
! kind(s * n)  = 4
! kind(n * big)= 8
! big * big    = 10000000000
! avg(1,2) wrong = 1.0000
! avg(1,2) right = 1.5000
! (1,1) * 2.0_dp = 2.00 2.00
