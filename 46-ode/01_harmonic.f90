! -----------------------------------------------------------------------------
! 01_harmonic.f90 - Euler and classical RK4 on the harmonic oscillator
!
! Run:  scripts/run.sh 46-ode/01_harmonic.f90
! -----------------------------------------------------------------------------
!
! y'' = -y, written as a first-order pair:
!   y' = v
!   v' = -y
! with y(0) = 1, v(0) = 0. The solution is y(t) = cos(t).
!
! Euler advances each equation with the slope at the start of the step.
! RK4 samples the slope four times. Both are checked against cos(1.0)
! inside the program.

program harmonic
  implicit none (type, external)

  real :: y, v

  call euler(1.0, 0.0, 0.1, 10, y, v)
  print '(a, l1)', 'euler within 0.05: ', abs(y - cos(1.0)) < 0.05

  call rk4(1.0, 0.0, 0.2, 5, y, v)
  print '(a, l1)', 'rk4 within 1e-4: ', abs(y - cos(1.0)) < 1.0e-4

contains

  pure subroutine slope(y, v, dy, dv)
    real, intent(in) :: y, v
    real, intent(out) :: dy, dv
    dy = v
    dv = -y
  end subroutine slope

  pure subroutine euler(y0, v0, h, steps, y, v)
    real, intent(in) :: y0, v0, h
    integer, intent(in) :: steps
    real, intent(out) :: y, v
    real :: dy, dv
    integer :: k

    y = y0
    v = v0
    do k = 1, steps
      call slope(y, v, dy, dv)
      y = y + h * dy
      v = v + h * dv
    end do
  end subroutine euler

  pure subroutine rk4(y0, v0, h, steps, y, v)
    real, intent(in) :: y0, v0, h
    integer, intent(in) :: steps
    real, intent(out) :: y, v
    real :: dy1, dv1, dy2, dv2, dy3, dv3, dy4, dv4
    integer :: k

    y = y0
    v = v0
    do k = 1, steps
      call slope(y, v, dy1, dv1)
      call slope(y + 0.5 * h * dy1, v + 0.5 * h * dv1, dy2, dv2)
      call slope(y + 0.5 * h * dy2, v + 0.5 * h * dv2, dy3, dv3)
      call slope(y + h * dy3, v + h * dv3, dy4, dv4)
      y = y + (h / 6.0) * (dy1 + 2.0 * dy2 + 2.0 * dy3 + dy4)
      v = v + (h / 6.0) * (dv1 + 2.0 * dv2 + 2.0 * dv3 + dv4)
    end do
  end subroutine rk4

end program harmonic

! Output:
! euler within 0.05: T
! rk4 within 1e-4: T
