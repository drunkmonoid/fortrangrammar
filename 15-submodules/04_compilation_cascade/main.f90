! main.f90 - depends only on geometry.mod, never on the submodule.
program main
  use geometry, only: distance
  implicit none (type, external)
  print '(a, f0.4)', 'distance((0,0), (3,4)) = ', distance(0.0, 0.0, 3.0, 4.0)
end program main
