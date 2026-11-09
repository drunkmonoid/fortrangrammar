! -----------------------------------------------------------------------------
! demo.f90 - dgemv and dgemm beside the same product written as loops
!
! Build: scripts/run.sh 42-blas/01_gemv_gemm/
! -----------------------------------------------------------------------------
!
! A is stored by columns, as chapter 07 does:
!
!   | 1  3 |      memory: 1, 2, 3, 4
!   | 2  4 |
!
! lda is 2. x = [1, 1] gives A x = [4, 6]. B is the identity, so A B = A.

program blas_demo
  use, intrinsic :: iso_fortran_env, only: real64
  implicit none (type, external)

  integer, parameter :: n = 2
  real(real64) :: a(n, n), b(n, n), c(n, n), c_ref(n, n)
  real(real64) :: x(n), y(n), y_ref(n)
  integer :: i, j, k

  interface
    subroutine dgemv(trans, m, n, alpha, a, lda, x, incx, beta, y, incy)
      import :: real64
      character(len=1), intent(in) :: trans
      integer, intent(in) :: m, n, lda, incx, incy
      real(real64), intent(in) :: alpha, beta
      real(real64), intent(in) :: a(lda, *), x(*)
      real(real64), intent(inout) :: y(*)
    end subroutine dgemv

    subroutine dgemm(transa, transb, m, n, k, alpha, a, lda, b, ldb, beta, c, ldc)
      import :: real64
      character(len=1), intent(in) :: transa, transb
      integer, intent(in) :: m, n, k, lda, ldb, ldc
      real(real64), intent(in) :: alpha, beta
      real(real64), intent(in) :: a(lda, *), b(ldb, *)
      real(real64), intent(inout) :: c(ldc, *)
    end subroutine dgemm
  end interface

  a = reshape([1.0_real64, 2.0_real64, 3.0_real64, 4.0_real64], [n, n])
  b = reshape([1.0_real64, 0.0_real64, 0.0_real64, 1.0_real64], [n, n])
  x = 1.0_real64

  y = 0.0_real64
  call dgemv('n', n, n, 1.0_real64, a, n, x, 1, 0.0_real64, y, 1)
  y_ref = 0.0_real64
  do j = 1, n
    do i = 1, n
      y_ref(i) = y_ref(i) + a(i, j) * x(j)
    end do
  end do
  if (any(nint(y) /= nint(y_ref))) error stop 'gemv disagrees with the loops'
  print '(a, *(i0, 1x))', 'y = ', nint(y)

  c = 0.0_real64
  call dgemm('n', 'n', n, n, n, 1.0_real64, a, n, b, n, 0.0_real64, c, n)
  c_ref = 0.0_real64
  do j = 1, n
    do k = 1, n
      do i = 1, n
        c_ref(i, j) = c_ref(i, j) + a(i, k) * b(k, j)
      end do
    end do
  end do
  if (any(nint(c) /= nint(c_ref))) error stop 'gemm disagrees with the loops'
  print '(a, *(i0, 1x))', 'c = ', nint(c)

end program blas_demo
