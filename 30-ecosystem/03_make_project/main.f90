! main.f90 - depends on convert.
program main
  use convert, only: miles_to_km
  implicit none (type, external)
  print '(a, *(1x, f0.3))', 'km:', miles_to_km([1.0, 26.2, 100.0])
end program main
