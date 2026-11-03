! -----------------------------------------------------------------------------
! 08_floating_point_pitfalls.f90 - classic numerical traps
!
! Run:  scripts/run.sh 25-numeric-ieee/08_floating_point_pitfalls.f90
! -----------------------------------------------------------------------------
!
! 1. Summation order matters: adding small values to a large one loses
!    them. Sum small-to-large, or use compensated (Kahan) summation.
! 2. Catastrophic cancellation: subtracting nearly equal numbers leaves
!    only noise. Rewrite the formula (e.g. the stable quadratic root).
! 3. Exact comparisons: test |a - b| <= tol * max(|a|, |b|).
! 4. Decimal fractions like 0.1 are not representable in binary.
! 5. -ffast-math / -Ofast allow reassociation and break Kahan summation
!    and NaN checks - do not use them for numerically sensitive code.

module stable
  use, intrinsic :: iso_fortran_env, only: sp => real32, dp => real64
  implicit none (type, external)
contains

  pure real(sp) function kahan_sum(x)
    real(sp), intent(in) :: x(:)
    real(sp) :: c, y, t
    integer :: i
    kahan_sum = 0
    c = 0
    do i = 1, size(x)
      y = x(i) - c
      t = kahan_sum + y
      c = (t - kahan_sum) - y        ! the part of y that was lost
      kahan_sum = t
    end do
  end function kahan_sum

  pure logical function close_to(a, b, rel_tol)
    real(dp), intent(in) :: a, b, rel_tol
    close_to = abs(a - b) <= rel_tol * max(abs(a), abs(b))
  end function close_to

end module stable

program floating_point_pitfalls
  use, intrinsic :: iso_fortran_env, only: sp => real32, dp => real64
  use stable, only: kahan_sum, close_to
  implicit none (type, external)

  real(sp), allocatable :: x(:)
  real(sp) :: naive
  real(dp) :: a, b, c, r_naive, r_stable
  integer :: i

  ! 1. One big value plus a million small ones (single precision).
  x = [1.0e8_sp, [(1.0_sp, i = 1, 1000000)]]
  naive = 0
  do i = 1, size(x)
    naive = naive + x(i)
  end do
  print '(a, f0.1)', 'exact sum         : ', 1.0e8_dp + 1.0e6_dp
  print '(a, f0.1)', 'naive single sum  : ', naive
  print '(a, f0.1)', 'kahan single sum  : ', kahan_sum(x)

  ! 2. Small root of x**2 + 1e8 x + 1 = 0.
  a = 1; b = 1.0e8_dp; c = 1
  r_naive = (-b + sqrt(b * b - 4 * a * c)) / (2 * a)
  r_stable = (2 * c) / (-b - sqrt(b * b - 4 * a * c))
  print '(a, es23.15)', 'naive small root  : ', r_naive
  print '(a, es23.15)', 'stable small root : ', r_stable

  ! 3./4. Comparing decimal fractions.
  print '(a, l1)', '0.1 + 0.2 == 0.3  : ', 0.1_dp + 0.2_dp == 0.3_dp
  print '(a, l1)', 'close_to(..)      : ', close_to(0.1_dp + 0.2_dp, 0.3_dp, 1.0e-12_dp)

end program floating_point_pitfalls

! Output:
! exact sum         : 101000000.0
! naive single sum  : 100000000.0
! kahan single sum  : 101000000.0
! naive small root  :  -7.450580596923828E-09
! stable small root :  -1.000000000000000E-08
! 0.1 + 0.2 == 0.3  : F
! close_to(..)      : T
