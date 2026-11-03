! -----------------------------------------------------------------------------
! 03_element_order.f90 - column-major storage
!
! Run:  scripts/run.sh 07-arrays-fundamentals/03_element_order.f90
! -----------------------------------------------------------------------------
!
! Fortran stores arrays in COLUMN-MAJOR order: the FIRST index varies
! fastest. For a(3, 2) the elements sit in memory as
!
!     a(1,1) a(2,1) a(3,1) a(1,2) a(2,2) a(3,2)
!
! This "array element order" is used by:
!   * reshape, pack, unpack and array constructors,
!   * list-directed I/O of a whole array,
!   * passing an array to an explicit-shape or assumed-size dummy,
!   * DATA statements.
!
! Performance rule: make the innermost loop run over the FIRST index, so
! memory is accessed sequentially. This is the opposite of C.

program element_order
  implicit none (type, external)

  integer :: a(3, 2)
  integer :: i, j, k

  ! Fill in memory order and show where each value lands.
  k = 0
  do j = 1, 2          ! outer loop: last index
    do i = 1, 3        ! inner loop: first index (contiguous in memory)
      k = k + 1
      a(i, j) = k
    end do
  end do

  print '(a)', 'a(i, j) = position in memory:'
  do i = 1, 3
    print '(2(i4))', a(i, :)
  end do

  ! Whole-array output uses element order.
  print '(a, *(1x, i0))', 'print a  :', a

  ! reshape fills in element order too, so this rebuilds the same array.
  print '(a, l1)', 'reshape matches: ', all(a == reshape([1, 2, 3, 4, 5, 6], [3, 2]))

  ! order= lets reshape fill dimensions in another order (row-major here).
  a = reshape([1, 2, 3, 4, 5, 6], [3, 2], order=[2, 1])
  print '(a)', 'row-major fill with order=[2,1]:'
  do i = 1, 3
    print '(2(i4))', a(i, :)
  end do

end program element_order

! Output:
! a(i, j) = position in memory:
!    1   4
!    2   5
!    3   6
! print a  : 1 2 3 4 5 6
! reshape matches: T
! row-major fill with order=[2,1]:
!    1   2
!    3   4
!    5   6
