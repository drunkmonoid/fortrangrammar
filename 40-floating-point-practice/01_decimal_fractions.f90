! -----------------------------------------------------------------------------
! 01_decimal_fractions.f90 - which decimal fractions are exact
!
! Run:  scripts/run.sh 40-floating-point-practice/01_decimal_fractions.f90
! -----------------------------------------------------------------------------
!
! real64 is binary. A value is exact only when it is a multiple of a
! power of two inside the range of the format.
!
!   0.5, 0.25 and 0.125 are exact, and so is their sum 0.875.
!   0.1 is not. 0.1 + 0.2 and 0.3 round to different binary values,
!   and adding 0.1 ten times does not land on 1.
!
! Rebuild this file with -O3 -ffast-math to see the third line allowed
! to change. The first two are properties of the literals themselves.

program decimal_fractions
  use, intrinsic :: iso_fortran_env, only: dp => real64
  implicit none (type, external)

  real(dp) :: s
  integer :: i

  print '(a, l1)', '0.1 + 0.2 /= 0.3: ', (0.1_dp + 0.2_dp) /= 0.3_dp
  print '(a, l1)', '1/2 + 1/4 + 1/8 == 7/8: ', &
      (0.5_dp + 0.25_dp + 0.125_dp) == 0.875_dp

  s = 0.0_dp
  do i = 1, 10
    s = s + 0.1_dp
  end do
  print '(a, l1)', 'ten 0.1 sums /= 1: ', s /= 1.0_dp

end program decimal_fractions

! Output:
! 0.1 + 0.2 /= 0.3: T
! 1/2 + 1/4 + 1/8 == 7/8: T
! ten 0.1 sums /= 1: T
