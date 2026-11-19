! Exercise 35: the mean of 2, 4, 6, 8, written with sum and size.
program ex35
  implicit none (type, external)

  integer :: samples(4)

  samples = [2, 4, 6, 8]
  print '(a, i0, 1x, i0)', 'count mean = ', size(samples), sum(samples) / size(samples)

end program ex35

! Output:
! count mean = 4 5
