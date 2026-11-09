! -----------------------------------------------------------------------------
! 02_jacobi.f90 - two Jacobi iterations from zero
!
! Run:  scripts/run.sh 44-sparse/02_jacobi.f90
! -----------------------------------------------------------------------------
!
! Jacobi updates every unknown from the previous vector:
!
!   x_i = (b_i - sum_{j /= i} a_ij x_j) / a_ii
!
! A is the same second-difference matrix as in 01_csr_matvec.f90, stored
! dense here so the iteration is visible. b = [2, -2, 2]. From x = 0 the
! first iteration is b divided by the diagonal, [1, -1, 1]. The second is
! [0.5, 0, 0.5]. Those halves are exact in binary, so twice the vector
! is the integer vector [1, 0, 1].

program jacobi
  implicit none (type, external)

  integer, parameter :: n = 3
  real :: a(n, n), b(n), x(n), xnew(n), acc
  integer :: step, i, j

  a = reshape([2, -1, 0, -1, 2, -1, 0, -1, 2], [n, n])
  b = [2, -2, 2]
  x = 0

  do step = 1, 2
    do i = 1, n
      acc = b(i)
      do j = 1, n
        if (j /= i) acc = acc - a(i, j) * x(j)
      end do
      xnew(i) = acc / a(i, i)
    end do
    x = xnew
  end do

  print '(a, 3(1x, i0))', 'twice x =', nint(2 * x)

end program jacobi

! Output:
! twice x = 1 0 1
