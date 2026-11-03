! @build skip needs the Fortran stdlib (fpm dependency stdlib = "*", or a CMake install)
! -----------------------------------------------------------------------------
! 07_stdlib_example.f90 - a taste of the Fortran Standard Library
!
! Build: add `stdlib = "*"` to [dependencies] in fpm.toml and `fpm run`
! -----------------------------------------------------------------------------
!
! stdlib (https://github.com/fortran-lang/stdlib) is the community's
! de-facto standard library - not part of the ISO standard. Modules include:
!   stdlib_string_type, stdlib_strings   string type, to_string, split...
!   stdlib_sorting                       sort, ord_sort, sort_index
!   stdlib_stats                         mean, var, median, corr, moment
!   stdlib_linalg                        solve, inv, det, eig, svd, lstsq
!   stdlib_io, stdlib_io_npy             loadtxt, savetxt, .npy files
!   stdlib_hashmaps, stdlib_bitsets      containers
!   stdlib_random, stdlib_stats_distribution_*   random distributions
!   stdlib_math                          linspace, logspace, clip, arange
!   stdlib_logger, stdlib_error          logging, check(), error_stop

program stdlib_example
  use stdlib_math, only: linspace
  use stdlib_stats, only: mean, var, median
  use stdlib_sorting, only: sort
  use stdlib_strings, only: to_string
  use stdlib_io, only: savetxt
  implicit none (type, external)

  real :: x(5) = [3.0, 1.0, 4.0, 1.0, 5.0]
  real :: grid(11)

  grid = linspace(0.0, 1.0, 11)
  call sort(x)
  print '(a)', 'sorted: ' // to_string(x(1)) // ' ... ' // to_string(x(5))
  print '(3(a, g0))', 'mean ', mean(x), ', var ', var(x), ', median ', median(x)
  call savetxt('grid.txt', reshape(grid, [11, 1]))

end program stdlib_example
