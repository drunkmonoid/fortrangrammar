! main.f90 - top layer: USEs physics (and constants for the kind).
program main
  use constants, only: dp
  use physics, only: pendulum_period, projectile_range
  implicit none (type, external)

  print '(a, f0.4, a)', 'period of a 1 m pendulum: ', pendulum_period(1.0_dp), ' s'
  print '(a, f0.2, a)', 'range at 20 m/s, 45 deg : ', projectile_range(20.0_dp, 45.0_dp), ' m'
end program main
