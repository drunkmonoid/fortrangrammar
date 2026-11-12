! Linear regression wrapper over a tabulated array of (x, y) observations.
! Shares the explicit normal-equations solver from phase 95 (95-least-squares):
!   [ n,       sum(x)  ] [ intercept ]   [ sum(y)   ]
!   [ sum(x),  sum(x^2)] [ slope     ] = [ sum(x*y) ]

module regression_m
  use, intrinsic :: iso_fortran_env, only: real64
  implicit none (type, external)
  private
  public :: fit_line

contains

  subroutine fit_line(xs, ys, intercept, slope)
    real(real64), intent(in) :: xs(:), ys(:)
    real(real64), intent(out) :: intercept, slope
    real(real64) :: n_pts, sx, sy, sxx, sxy, det

    n_pts = real(size(xs), real64)
    sx = sum(xs)
    sy = sum(ys)
    sxx = sum(xs * xs)
    sxy = sum(xs * ys)

    det = n_pts * sxx - sx * sx
    intercept = (sxx * sy - sx * sxy) / det
    slope = (n_pts * sxy - sx * sy) / det
  end subroutine fit_line

end module regression_m

program regression_demo
  use, intrinsic :: iso_fortran_env, only: real64, output_unit
  use regression_m, only: fit_line
  implicit none (type, external)

  real(real64), parameter :: xs(3) = [0.0_real64, 1.0_real64, 2.0_real64]
  real(real64), parameter :: ys(3) = [1.0_real64, 3.0_real64, 5.0_real64]
  real(real64) :: intercept, slope

  call fit_line(xs, ys, intercept, slope)

  write(output_unit, '(a,1x,i0)') 'slope =', nint(slope)
  write(output_unit, '(a,1x,i0)') 'intercept =', nint(intercept)

end program regression_demo

! Output:
! slope = 2
! intercept = 1
