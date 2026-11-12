! -----------------------------------------------------------------------------
! 01_richardson.f90 - Symmetric difference and Richardson extrapolation
!
! Run:  scripts/run.sh 96-richardson/01_richardson.f90
! -----------------------------------------------------------------------------
!
! Computes the symmetric difference quotient:
!   D(h) = (f(x + h) - f(x - h)) / (2 * h)
! for f(x) = x**2 at x = 1 with h = 0.5 (and h/2 = 0.25).
!
! By Taylor expansion:
!   D(h) = f'(x) + (h**2 / 6) * f'''(x) + O(h**4)
! For any quadratic polynomial f(x), f'''(x) = 0 identically, so the leading
! O(h**2) error term vanishes and D(h) recovers the exact derivative f'(1) = 2.
! Richardson extrapolation R = (4 * D(h/2) - D(h)) / 3 eliminates the O(h**2)
! term for general smooth functions, raising accuracy to O(h**4).

program richardson_demo
  use, intrinsic :: iso_fortran_env, only: real64, output_unit
  implicit none (type, external)

  real(real64), parameter :: x = 1.0_real64
  real(real64), parameter :: h = 0.5_real64
  real(real64) :: d_h, d_half, rich, exact
  logical :: ok

  d_h = (f(x + h) - f(x - h)) / (2.0_real64 * h)
  d_half = (f(x + 0.5_real64 * h) - f(x - 0.5_real64 * h)) / h
  rich = (4.0_real64 * d_half - d_h) / 3.0_real64

  exact = 2.0_real64 * x
  ok = (abs(d_h - exact) < 1.0e-12_real64) .and. &
       (abs(rich - exact) < 1.0e-12_real64)

  write(output_unit, '(a,1x,l1)') 'matches derivative:', ok

contains

  pure function f(val) result(res)
    real(real64), intent(in) :: val
    real(real64) :: res
    res = val * val
  end function f

end program richardson_demo

! Output:
! matches derivative: T
