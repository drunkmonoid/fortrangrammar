! -----------------------------------------------------------------------------
! 02_contiguous_argument.f90 - contiguous dummy, column, and a strided row
!
! Run:  scripts/run.sh 39-array-performance/02_contiguous_argument.f90
! -----------------------------------------------------------------------------
!
! a(:, 1) is one column: contiguous, first index varying.
! a(1, :) is one row: a stride of size(a, 1) between elements.
!
! The dummy is contiguous and intent(inout). The column is passed as it
! is. The row is copied into a temporary, doubled, and copied back, so
! the printed matrix is still the one the source asked for. Compile with
! -Warray-temporaries to see the copy named.

program contiguous_argument
  implicit none (type, external)

  integer :: a(2, 3)

  ! Column-major fill: columns [1, 2], [3, 4], [5, 6].
  ! Doubling column 1, then row 1, leaves [4, 4], [6, 4], [10, 6].
  a = reshape([1, 2, 3, 4, 5, 6], [2, 3])
  call double(a(:, 1))
  call double(a(1, :))

  print '(a, 6(1x, i0))', 'a =', a

contains

  subroutine double(x)
    integer, intent(inout), contiguous :: x(:)
    x = x * 2
  end subroutine double

end program contiguous_argument

! Output:
! a = 4 4 6 4 10 6
