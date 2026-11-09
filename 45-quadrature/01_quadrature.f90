! -----------------------------------------------------------------------------
! 01_quadrature.f90 - trapezoid and Simpson on a known integral
!
! Run:  scripts/run.sh 45-quadrature/01_quadrature.f90
! -----------------------------------------------------------------------------
!
! The integral of x**2 from 0 to 1 is 1/3.
!
! Trapezoid, two panels of width 1/2:
!   (h/2) * (f(0) + 2*f(1/2) + f(1)) = 0.375
! Simpson, same nodes:
!   (h/3) * (f(0) + 4*f(1/2) + f(1)) = 1/3
! Simpson is exact for polynomials up to degree 3, so this one matches.

program quadrature
  implicit none (type, external)

  real :: trap, simp

  trap = trapezoid(0.0, 1.0, 2)
  simp = simpson(0.0, 1.0, 2)
  print '(a, f5.3)', 'trapezoid = ', trap
  print '(a, l1)', 'simpson is 1/3: ', abs(simp - 1.0 / 3.0) < 1.0e-6

contains

  pure real function f(x)
    real, intent(in) :: x
    f = x * x
  end function f

  pure real function trapezoid(a, b, panels) result(total)
    real, intent(in) :: a, b
    integer, intent(in) :: panels
    real :: h, x
    integer :: i

    h = (b - a) / real(panels)
    total = 0.5 * (f(a) + f(b))
    do i = 1, panels - 1
      x = a + real(i) * h
      total = total + f(x)
    end do
    total = total * h
  end function trapezoid

  pure real function simpson(a, b, panels) result(total)
    real, intent(in) :: a, b
    integer, intent(in) :: panels
    real :: h
    integer :: i

    h = (b - a) / real(panels)
    total = f(a) + f(b)
    do i = 1, panels - 1, 2
      total = total + 4.0 * f(a + real(i) * h)
    end do
    do i = 2, panels - 2, 2
      total = total + 2.0 * f(a + real(i) * h)
    end do
    total = total * h / 3.0
  end function simpson

end program quadrature

! Output:
! trapezoid = 0.375
! simpson is 1/3: T
