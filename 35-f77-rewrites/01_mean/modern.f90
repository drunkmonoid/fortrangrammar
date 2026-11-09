! 01_mean/modern.f90 - the same mean, free form
!
! Built by 01_mean/build.sh.

program mean_modern
  implicit none (type, external)

  integer, parameter :: a(*) = [2, 4, 6, 8]
  integer :: s

  s = sum(a)
  print '(a, i0)', 'sum = ', s
  print '(a, i0)', 'mean = ', s / size(a)

end program mean_modern
