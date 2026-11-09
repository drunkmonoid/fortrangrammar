! -----------------------------------------------------------------------------
! 01_csr_matvec.f90 - COO to CSR, then a matrix-vector product
!
! Run:  scripts/run.sh 44-sparse/01_csr_matvec.f90
! -----------------------------------------------------------------------------
!
! COO keeps one (row, column, value) triple per nonzero, in any order.
! CSR keeps the nonzeros of each row together:
!
!   row_ptr(i) .. row_ptr(i+1)-1    are the entries of row i
!
! row_ptr has n+1 entries and starts at 1. Building it is a count per
! row followed by a prefix sum. x = [1, 2, 3] gives A x = [0, 0, 4].

program csr_matvec
  implicit none (type, external)

  integer, parameter :: n = 3, nnz = 7
  integer :: row(nnz), col(nnz), val(nnz)
  integer :: row_ptr(n + 1), csr_col(nnz), csr_val(nnz)
  integer :: next(n + 1)
  integer :: x(n), y(n)
  integer :: i, k

  row = [1, 1, 2, 2, 2, 3, 3]
  col = [1, 2, 1, 2, 3, 2, 3]
  val = [2, -1, -1, 2, -1, -1, 2]
  x = [1, 2, 3]

  row_ptr = 0
  do k = 1, nnz
    row_ptr(row(k) + 1) = row_ptr(row(k) + 1) + 1
  end do
  row_ptr(1) = 1
  do i = 1, n
    row_ptr(i + 1) = row_ptr(i) + row_ptr(i + 1)
  end do

  next = row_ptr
  do k = 1, nnz
    csr_col(next(row(k))) = col(k)
    csr_val(next(row(k))) = val(k)
    next(row(k)) = next(row(k)) + 1
  end do

  y = 0
  do i = 1, n
    do k = row_ptr(i), row_ptr(i + 1) - 1
      y(i) = y(i) + csr_val(k) * x(csr_col(k))
    end do
  end do

  print '(a, 4(1x, i0))', 'row_ptr =', row_ptr
  print '(a, 3(1x, i0))', 'y =', y

end program csr_matvec

! Output:
! row_ptr = 1 3 6 8
! y = 0 0 4
