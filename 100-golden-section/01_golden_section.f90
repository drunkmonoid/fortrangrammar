! Golden-section search to minimise f(x) = (x - 2)**2 on [0, 5].
! Stopping checks the bracket width against a tolerance up to max_steps iterations.

module golden_m
  use, intrinsic :: iso_fortran_env, only: real64
  implicit none (type, external)
  private
  public :: golden_minimize

contains

  pure real(real64) function objective(x) result(y)
    real(real64), intent(in) :: x
    y = (x - 2.0_real64)**2
  end function objective

  subroutine golden_minimize(a_in, b_in, max_steps, bracket_tol, x_min, steps_used)
    real(real64), intent(in) :: a_in, b_in, bracket_tol
    integer, intent(in) :: max_steps
    real(real64), intent(out) :: x_min
    integer, intent(out) :: steps_used

    real(real64), parameter :: phi = 0.5_real64 * (sqrt(5.0_real64) - 1.0_real64)
    real(real64) :: a, b, c, d, fc, fd
    integer :: step

    a = a_in
    b = b_in
    c = b - phi * (b - a)
    d = a + phi * (b - a)
    fc = objective(c)
    fd = objective(d)

    steps_used = 0
    do step = 1, max_steps
      if (b - a <= bracket_tol) exit
      steps_used = step
      if (fc < fd) then
        b = d
        d = c
        fd = fc
        c = b - phi * (b - a)
        fc = objective(c)
      else
        a = c
        c = d
        fc = fd
        d = a + phi * (b - a)
        fd = objective(d)
      end if
    end do

    x_min = 0.5_real64 * (a + b)
  end subroutine golden_minimize

end module golden_m

program golden_section_demo
  use, intrinsic :: iso_fortran_env, only: real64, output_unit
  use golden_m, only: golden_minimize
  implicit none (type, external)

  real(real64) :: x_min
  integer :: steps_used
  logical :: within_tol

  call golden_minimize(0.0_real64, 5.0_real64, max_steps=30, &
    bracket_tol=1.0e-3_real64, x_min=x_min, steps_used=steps_used)
  within_tol = abs(x_min - 2.0_real64) < 0.1_real64

  write(output_unit, '(a,1x,i0)') 'steps:', steps_used
  write(output_unit, '(a,1x,l1)') 'within 0.1 of 2:', within_tol

end program golden_section_demo

! Output:
! steps: 18
! within 0.1 of 2: T
