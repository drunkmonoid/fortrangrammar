! -----------------------------------------------------------------------------
! 01_traversal.f90 - column-major traversal versus row-major traversal
!
! Run:  scripts/run.sh 39-array-performance/01_traversal.f90
! -----------------------------------------------------------------------------
!
! a(i, j) is stored with i consecutive. The inner loop should be i.
! Both loops add the same elements, so the sums match. The difference is
! which addresses are next to each other, and that does not show up in
! the checksum.

program traversal
  implicit none (type, external)

  integer, parameter :: m = 3, n = 4
  integer :: a(m, n), i, j, k
  integer :: by_column, by_row

  k = 0
  do j = 1, n
    do i = 1, m
      k = k + 1
      a(i, j) = k
    end do
  end do

  by_column = 0
  do j = 1, n
    do i = 1, m
      by_column = by_column + a(i, j)
    end do
  end do

  by_row = 0
  do i = 1, m
    do j = 1, n
      by_row = by_row + a(i, j)
    end do
  end do

  print '(a, i0)', 'column-major sum = ', by_column
  print '(a, i0)', 'row-major sum = ', by_row
  print '(a, i0)', 'intrinsic sum = ', sum(a)

end program traversal

! Output:
! column-major sum = 78
! row-major sum = 78
! intrinsic sum = 78
