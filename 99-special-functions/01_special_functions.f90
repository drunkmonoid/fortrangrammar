! Truncated Taylor series for exp(x) and erf(x) in pure Fortran.
! exp(1) uses 12 terms (k = 0..11; 1/12! ~ 2.1e-9 < 1e-6).
! erf(x) uses the power series sum_{k=0}^{n-1} (-1)^k * x^(2k+1) / (k! * (2k+1)) * 2/sqrt(pi)
! with 12 terms; at x = 0 every term vanishes identically.

module special_m
  use, intrinsic :: iso_fortran_env, only: real64
  implicit none (type, external)
  private
  public :: series_exp, series_erf

contains

  pure real(real64) function series_exp(x, n_terms) result(total)
    real(real64), intent(in) :: x
    integer, intent(in) :: n_terms
    real(real64) :: term
    integer :: k

    total = 0.0_real64
    term = 1.0_real64
    do k = 0, n_terms - 1
      total = total + term
      term = term * x / real(k + 1, real64)
    end do
  end function series_exp

  pure real(real64) function series_erf(x, n_terms) result(val)
    real(real64), intent(in) :: x
    integer, intent(in) :: n_terms
    real(real64), parameter :: two_over_sqrt_pi = 2.0_real64 / sqrt(acos(-1.0_real64))
    real(real64) :: x2, term, total
    integer :: k

    total = 0.0_real64
    term = x
    x2 = x * x
    do k = 0, n_terms - 1
      total = total + term / real(2 * k + 1, real64)
      term = -term * x2 / real(k + 1, real64)
    end do
    val = two_over_sqrt_pi * total
  end function series_erf

end module special_m

program special_functions_demo
  use, intrinsic :: iso_fortran_env, only: real64, output_unit
  use special_m, only: series_exp, series_erf
  implicit none (type, external)

  integer, parameter :: n_terms = 12
  real(real64), parameter :: tol = 1.0e-6_real64
  real(real64) :: e_approx, erf0
  logical :: exp_ok, erf0_ok

  e_approx = series_exp(1.0_real64, n_terms)
  erf0 = series_erf(0.0_real64, n_terms)

  exp_ok = abs(e_approx - exp(1.0_real64)) < tol
  erf0_ok = (erf0 == 0.0_real64)

  write(output_unit, '(a,1x,l1)') 'exp(1) within 1e-6 (12 terms):', exp_ok
  write(output_unit, '(a,1x,l1)') 'erf(0) == 0:', erf0_ok

end program special_functions_demo

! Output:
! exp(1) within 1e-6 (12 terms): T
! erf(0) == 0: T
