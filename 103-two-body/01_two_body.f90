! Explicit Euler step for a unit-mu planar two-body problem.
! Initial condition: r = (1, 0), v = (0, 1), mu = 1, acceleration a = -r / |r|^3.

module twobody_m
  use, intrinsic :: iso_fortran_env, only: real64
  implicit none (type, external)
  private
  public :: euler_step, radius

contains

  pure subroutine euler_step(dt, pos, vel)
    real(real64), intent(in) :: dt
    real(real64), intent(inout) :: pos(2), vel(2)
    real(real64) :: r, acc(2)

    r = hypot(pos(1), pos(2))
    acc = -pos / (r * r * r)
    pos = pos + dt * vel
    vel = vel + dt * acc
  end subroutine euler_step

  pure real(real64) function radius(pos)
    real(real64), intent(in) :: pos(2)
    radius = hypot(pos(1), pos(2))
  end function radius

end module twobody_m

program two_body_demo
  use, intrinsic :: iso_fortran_env, only: real64, output_unit
  use twobody_m, only: euler_step, radius
  implicit none (type, external)

  real(real64) :: pos(2), vel(2), r0, r1
  logical :: zero_ok, small_ok

  pos = [1.0_real64, 0.0_real64]
  vel = [0.0_real64, 1.0_real64]
  call euler_step(0.0_real64, pos, vel)
  r0 = radius(pos)
  zero_ok = (r0 == 1.0_real64)

  pos = [1.0_real64, 0.0_real64]
  vel = [0.0_real64, 1.0_real64]
  call euler_step(0.1_real64, pos, vel)
  r1 = radius(pos)
  small_ok = (abs(r1 - 1.0_real64) < 0.05_real64)

  write(output_unit, '(a,1x,l1)') 'zero step:', zero_ok
  write(output_unit, '(a,1x,l1)') 'small step near 1:', small_ok

end program two_body_demo

! Output:
! zero step: T
! small step near 1: T
