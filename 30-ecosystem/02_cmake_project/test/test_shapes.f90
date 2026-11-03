! test/test_shapes.f90 - run by ctest; nonzero exit status = failure.
program test_shapes
  use shapes, only: circle_area
  implicit none (type, external)
  if (abs(circle_area(1.0) - acos(-1.0)) > 1.0e-6) error stop 'circle_area(1) wrong'
  print '(a)', 'test_shapes passed'
end program test_shapes
