! -----------------------------------------------------------------------------
! 04_manipulation.f90 - cshift, eoshift, transpose
!
! Run:  scripts/run.sh 09-array-intrinsics/04_manipulation.f90
! -----------------------------------------------------------------------------
!
!   cshift(array, shift [, dim])
!       Circular shift: elements leaving one end re-enter at the other.
!       Positive SHIFT moves elements toward LOWER indices (left).
!   eoshift(array, shift [, boundary] [, dim])
!       End-off shift: elements fall off, BOUNDARY (default 0 / .false. /
!       blanks) fills the vacated places.
!   transpose(matrix)
!       Rank-2 only: result(i, j) = matrix(j, i).
!
! For rank > 1, SHIFT may be an array (a different shift per row/column)
! and DIM chooses the direction (default 1).
! These are handy for stencils: neighbour(i) = cshift(a, 1)(i) = a(i+1).

program manipulation
  implicit none (type, external)

  integer :: v(5) = [1, 2, 3, 4, 5]
  integer :: m(3, 3)
  integer :: i

  print '(a, *(1x, i0))', 'cshift(v,  1)          :', cshift(v, 1)
  print '(a, *(1x, i0))', 'cshift(v, -1)          :', cshift(v, -1)
  print '(a, *(1x, i0))', 'eoshift(v, 2)          :', eoshift(v, 2)
  print '(a, *(1x, i0))', 'eoshift(v, -2, 99)     :', eoshift(v, -2, boundary=99)

  ! Periodic finite difference: a(i+1) - a(i-1)
  print '(a, *(1x, i0))', 'periodic central diff. :', cshift(v, 1) - cshift(v, -1)

  m = reshape([(i, i = 1, 9)], [3, 3])
  print '(a)', 'm:'
  do i = 1, 3
    print '(3i4)', m(i, :)
  end do

  print '(a)', 'cshift(m, shift=[0,1,2], dim=2)  (row i shifted by i-1):'
  associate (r => cshift(m, shift=[0, 1, 2], dim=2))
    do i = 1, 3
      print '(3i4)', r(i, :)
    end do
  end associate

  print '(a)', 'transpose(m):'
  associate (t => transpose(m))
    do i = 1, 3
      print '(3i4)', t(i, :)
    end do
  end associate

end program manipulation

! Output:
! cshift(v,  1)          : 2 3 4 5 1
! cshift(v, -1)          : 5 1 2 3 4
! eoshift(v, 2)          : 3 4 5 0 0
! eoshift(v, -2, 99)     : 99 99 1 2 3
! periodic central diff. : -3 2 2 2 -3
! m:
!    1   4   7
!    2   5   8
!    3   6   9
! cshift(m, shift=[0,1,2], dim=2)  (row i shifted by i-1):
!    1   4   7
!    5   8   2
!    9   3   6
! transpose(m):
!    1   2   3
!    4   5   6
!    7   8   9
