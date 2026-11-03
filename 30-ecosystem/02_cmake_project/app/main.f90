! app/main.f90
program main
  use shapes, only: circle_area
  implicit none (type, external)
  print '(a, f0.4)', 'circle_area(1.5) = ', circle_area(1.5)
end program main
