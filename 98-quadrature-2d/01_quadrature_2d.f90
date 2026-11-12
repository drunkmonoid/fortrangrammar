! Product composite Simpson rule for f(x, y) = x**2 + y**2 on [0, 1] x [0, 1].
! Uses 4 panels (5 nodes, even panel count) along each axis, matching phase 45.

module quad2d_m
  use, intrinsic :: iso_fortran_env, only: real64
  implicit none (type, external)
  private
  public :: simpson_weights, product_simpson_2d

contains

  subroutine simpson_weights(a, b, n_panels, x, w)
    real(real64), intent(in) :: a, b
    integer, intent(in) :: n_panels
    real(real64), allocatable, intent(out) :: x(:), w(:)
    real(real64) :: h
    integer :: i

    if (mod(n_panels, 2) /= 0 .or. n_panels < 2) then
      error stop 'simpson_weights: n_panels must be even and >= 2'
    end if

    allocate(x(0:n_panels), w(0:n_panels))
    h = (b - a) / real(n_panels, real64)
    do i = 0, n_panels
      x(i) = a + real(i, real64) * h
      if (i == 0 .or. i == n_panels) then
        w(i) = h / 3.0_real64
      else if (mod(i, 2) == 1) then
        w(i) = 4.0_real64 * h / 3.0_real64
      else
        w(i) = 2.0_real64 * h / 3.0_real64
      end if
    end do
  end subroutine simpson_weights

  pure real(real64) function integrand(x, y)
    real(real64), intent(in) :: x, y
    integrand = x**2 + y**2
  end function integrand

  real(real64) function product_simpson_2d(nx, ny) result(total)
    integer, intent(in) :: nx, ny
    real(real64), allocatable :: x(:), wx(:), y(:), wy(:)
    integer :: i, j

    call simpson_weights(0.0_real64, 1.0_real64, nx, x, wx)
    call simpson_weights(0.0_real64, 1.0_real64, ny, y, wy)

    total = 0.0_real64
    do j = 0, ny
      do i = 0, nx
        total = total + wx(i) * wy(j) * integrand(x(i), y(j))
      end do
    end do
  end function product_simpson_2d

end module quad2d_m

program quadrature_2d_demo
  use, intrinsic :: iso_fortran_env, only: real64, output_unit
  use quad2d_m, only: product_simpson_2d
  implicit none (type, external)

  integer, parameter :: nx_panels = 4, ny_panels = 4
  real(real64), parameter :: exact = 2.0_real64 / 3.0_real64
  real(real64), parameter :: tol = 1.0e-6_real64
  real(real64) :: approx
  logical :: matches

  approx = product_simpson_2d(nx_panels, ny_panels)
  matches = abs(approx - exact) < tol

  write(output_unit, '(a,1x,l1)') 'matches 2/3 within 1e-6:', matches

end program quadrature_2d_demo

! Output:
! matches 2/3 within 1e-6: T
