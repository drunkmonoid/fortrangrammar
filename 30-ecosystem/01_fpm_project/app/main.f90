! app/main.f90 - an executable using the library; `fpm run` builds and runs it.
program main
  use stats, only: dp, mean, variance
  implicit none (type, external)
  real(dp) :: x(5) = [2.0_dp, 4.0_dp, 4.0_dp, 5.0_dp, 7.0_dp]
  print '(a, f0.4, a, f0.4)', 'mean = ', mean(x), ', variance = ', variance(x)
end program main
