! -----------------------------------------------------------------------------
! 07_multidimensional.f90 - working with matrices and higher rank
!
! Run:  scripts/run.sh 07-arrays-fundamentals/07_multidimensional.f90
! -----------------------------------------------------------------------------
!
! Patterns for rank-2+ arrays:
!   * loop nests with the FIRST index innermost (column-major);
!   * row m(i, :) and column m(:, j) sections;
!   * reductions along a dimension: sum(m, dim=1) sums each column;
!   * printing a matrix row by row (list-directed output would print it
!     column by column).
!
! `do concurrent` (chapter 28) is the idiomatic way to say a loop nest
! has independent iterations.

program multidimensional
  implicit none (type, external)

  integer, parameter :: rows = 3, cols = 4
  real :: m(rows, cols), t(cols, rows)
  real :: cube(2, 2, 2)
  integer :: i, j

  ! Column-major loop nest: j outer, i inner.
  do j = 1, cols
    do i = 1, rows
      m(i, j) = 10 * i + j
    end do
  end do

  print '(a)', 'm, printed row by row:'
  do i = 1, rows
    print '(*(f6.0))', m(i, :)
  end do

  print '(a, *(f6.0))', 'column sums (dim=1):', sum(m, dim=1)
  print '(a, *(f6.0))', 'row sums    (dim=2):', sum(m, dim=2)

  t = transpose(m)
  print '(a, *(1x, i0))', 'shape(transpose(m)):', shape(t)
  print '(a, *(f6.0))', 't(:, 1) = m(1, :):', t(:, 1)

  ! Rank 3.
  cube = reshape([(real(i), i = 1, 8)], shape(cube))
  print '(a, *(f5.0))', 'cube(:, :, 2) flattened:', cube(:, :, 2)
  print '(a, f0.0)', 'sum over everything: ', sum(cube)

end program multidimensional

! Output:
! m, printed row by row:
!    11.   12.   13.   14.
!    21.   22.   23.   24.
!    31.   32.   33.   34.
! column sums (dim=1):   63.   66.   69.   72.
! row sums    (dim=2):   50.   90.  130.
! shape(transpose(m)): 4 3
! t(:, 1) = m(1, :):   11.   12.   13.   14.
! cube(:, :, 2) flattened:   5.   6.   7.   8.
! sum over everything: 36.
