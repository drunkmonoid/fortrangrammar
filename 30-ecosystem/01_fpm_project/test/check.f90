! test/check.f90 - `fpm test` runs every program in test/; nonzero exit = failure.
program check
  use stats, only: dp, mean, variance
  implicit none (type, external)
  real(dp), parameter :: tol = 1.0e-12_dp
  if (abs(mean([1.0_dp, 2.0_dp, 3.0_dp]) - 2.0_dp) > tol) error stop 'mean failed'
  if (abs(variance([1.0_dp, 2.0_dp, 3.0_dp]) - 1.0_dp) > tol) error stop 'variance failed'
  print '(a)', 'all stats tests passed'
end program check
