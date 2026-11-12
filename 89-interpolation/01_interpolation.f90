! -----------------------------------------------------------------------------
! 01_interpolation.f90 - Piecewise linear and Lagrange cubic interpolation
!
! Run:  scripts/run.sh 89-interpolation/01_interpolation.f90
! -----------------------------------------------------------------------------
!
! Samples f(x) = x**2 at x = [0, 1, 2, 3], y = [0, 1, 4, 9].
! At xq = 1.5:
!   - Linear interpolation uses the bracket [1, 2] -> 2.5 (strictly between 1 and 4,
!     but not exact because f'' /= 0).
!   - Cubic Lagrange interpolation uses the 4-point stencil x = [0, 1, 2, 3],
!     which reproduces every polynomial of degree <= 3 exactly, recovering 2.25.
!     We print nint(4 * value) = 9 so the output check stays integer-exact.
!
! For a packaged reusable 1-D interpolation library with C/Python ABI, see phase 74.

module interp_alg_m
  use, intrinsic :: iso_fortran_env, only: real64
  implicit none (type, external)
  private
  public :: linear_interp, lagrange_cubic

contains

  pure function linear_interp(x0, y0, x1, y1, xq) result(yq)
    real(real64), intent(in) :: x0, y0, x1, y1, xq
    real(real64) :: yq
    yq = y0 + (xq - x0) * (y1 - y0) / (x1 - x0)
  end function linear_interp

  pure function lagrange_cubic(xs, ys, xq) result(yq)
    real(real64), intent(in) :: xs(4), ys(4), xq
    real(real64) :: yq, basis
    integer :: i, j

    yq = 0.0_real64
    do i = 1, 4
      basis = 1.0_real64
      do j = 1, 4
        if (j /= i) then
          basis = basis * (xq - xs(j)) / (xs(i) - xs(j))
        end if
      end do
      yq = yq + ys(i) * basis
    end do
  end function lagrange_cubic

end module interp_alg_m

program interpolation_demo
  use, intrinsic :: iso_fortran_env, only: real64, output_unit
  use interp_alg_m, only: linear_interp, lagrange_cubic
  implicit none (type, external)

  real(real64) :: xs(4), ys(4), xq, y_lin, y_cub
  logical :: strictly_between

  xs = [0.0_real64, 1.0_real64, 2.0_real64, 3.0_real64]
  ys = xs**2
  xq = 1.5_real64

  ! Bracket [xs(2), xs(3)] = [1, 2]
  y_lin = linear_interp(xs(2), ys(2), xs(3), ys(3), xq)
  strictly_between = (y_lin > ys(2) .and. y_lin < ys(3))

  ! 4-point stencil [0, 1, 2, 3]
  y_cub = lagrange_cubic(xs, ys, xq)

  write(output_unit, '(a,1x,l1)') 'Linear strictly between samples:', strictly_between
  write(output_unit, '(a,1x,i0)') 'Cubic 4*value:', nint(4.0_real64 * y_cub)

end program interpolation_demo

! Output:
! Linear strictly between samples: T
! Cubic 4*value: 9
