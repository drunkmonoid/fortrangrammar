! Mandelbrot escape iterations using complex(real64) arithmetic.
! Tests z = z**2 + c starting from z = 0 up to max_iter steps;
! returns the 1-based escape iteration when |z|^2 > 4, or 0 if bounded.

module mandelbrot_m
  use, intrinsic :: iso_fortran_env, only: real64
  implicit none (type, external)
  private
  public :: escape_iter

contains

  pure integer function escape_iter(c, max_iter) result(iters)
    complex(real64), intent(in) :: c
    integer, intent(in) :: max_iter
    complex(real64) :: z
    integer :: k

    z = (0.0_real64, 0.0_real64)
    iters = 0
    do k = 1, max_iter
      z = z * z + c
      if (real(z, real64)**2 + aimag(z)**2 > 4.0_real64) then
        iters = k
        return
      end if
    end do
  end function escape_iter

end module mandelbrot_m

program mandelbrot_demo
  use, intrinsic :: iso_fortran_env, only: real64, output_unit
  use mandelbrot_m, only: escape_iter
  implicit none (type, external)

  integer, parameter :: max_iter = 20
  complex(real64), parameter :: pts(4) = [ &
    (0.0_real64, 0.0_real64), &
    (3.0_real64, 0.0_real64), &
    (-1.0_real64, 0.0_real64), &
    (0.5_real64, 0.5_real64) ]
  integer :: i

  do i = 1, size(pts)
    write(output_unit, '(a,i0,a,1x,i0)') 'point ', i, ':', escape_iter(pts(i), max_iter)
  end do

end program mandelbrot_demo

! Output:
! point 1: 0
! point 2: 1
! point 3: 0
! point 4: 5
