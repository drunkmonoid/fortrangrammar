! physics.f90 - middle layer: USEs constants, so constants.mod must exist
! before this file can be compiled.
module physics
  use constants, only: dp, pi, g
  implicit none (type, external)
  private
  public :: pendulum_period, projectile_range

contains

  pure real(dp) function pendulum_period(length)
    real(dp), intent(in) :: length
    pendulum_period = 2 * pi * sqrt(length / g)
  end function pendulum_period

  pure real(dp) function projectile_range(speed, angle_deg)
    real(dp), intent(in) :: speed, angle_deg
    projectile_range = speed**2 * sin(2 * angle_deg * pi / 180) / g
  end function projectile_range

end module physics
