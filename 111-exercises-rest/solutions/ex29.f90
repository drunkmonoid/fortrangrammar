! @flags -fopenmp
! Exercise 29: a reduction. MPI is left out; it needs another compiler wrapper.
program ex29
  implicit none (type, external)

  integer :: i, total

  total = 0
  !$omp parallel do reduction(+:total)
  do i = 1, 4
    total = total + i
  end do
  !$omp end parallel do
  print '(a, i0)', 'total = ', total

end program ex29

! Output:
! total = 10
