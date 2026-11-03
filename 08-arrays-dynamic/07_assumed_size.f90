! -----------------------------------------------------------------------------
! 07_assumed_size.f90 - assumed-size dummies: real :: a(*)
!
! Run:  scripts/run.sh 08-arrays-dynamic/07_assumed_size.f90
! -----------------------------------------------------------------------------
!
!   real, intent(in) :: a(*)          last bound is unknown
!   real, intent(in) :: m(lda, *)     all but the last dimension known
!
! Assumed size is the pre-F90 way of passing arrays of unknown size (it is
! still standard, not obsolescent). The procedure only gets the address of
! the first element:
!   * size(a), shape(a), ubound(a) and whole-array operations are NOT
!     allowed - the compiler does not know the extent;
!   * you must pass the size yourself and use sections a(1:n);
!   * no bounds checking is possible in the last dimension.
!
! You meet it in BLAS/LAPACK-style interfaces and in C interop. In new code
! use assumed shape `a(:)` or, for "any rank", assumed rank `a(..)`.

module assumed_size
  implicit none (type, external)
contains

  real function total(n, a)
    integer, intent(in) :: n
    real, intent(in) :: a(*)

    total = sum(a(1:n))          ! sum(a) would not compile
  end function total

  subroutine column_sums(lda, ncol, m)
    integer, intent(in) :: lda, ncol
    real, intent(in) :: m(lda, *)
    integer :: j

    do j = 1, ncol
      print '(a, i0, a, f0.1)', '  column ', j, ': ', sum(m(:, j))
    end do
  end subroutine column_sums

end module assumed_size

program assumed_size_demo
  use assumed_size, only: total, column_sums
  implicit none (type, external)

  real :: v(5) = [1.0, 2.0, 3.0, 4.0, 5.0]
  real :: grid(2, 3) = reshape([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], [2, 3])

  print '(a, f0.1)', 'total of first 3: ', total(3, v)
  print '(a)', 'column sums of a 2x3 matrix:'
  call column_sums(2, 3, grid)

end program assumed_size_demo

! Output:
! total of first 3: 6.0
! column sums of a 2x3 matrix:
!   column 1: 3.0
!   column 2: 7.0
!   column 3: 11.0
