! -----------------------------------------------------------------------------
! 01_cg.f90 - Conjugate Gradient solver on the 3x3 SPD matrix from chapter 44
!
! Run:  scripts/run.sh 93-conjugate-gradient/01_cg.f90
! -----------------------------------------------------------------------------
!
! Solves A x = b where A is the 3x3 symmetric positive-definite second-difference
! matrix from chapter 44 and b = [0, 0, 4], whose exact solution is x = [1, 2, 3].
!
! In exact arithmetic, CG converges in at most n = 3 steps. In real64, roundoff
! after 3 steps is O(1e-15), so maxval(abs(r)) < 1e-12 guarantees that
! maxval(nint(abs(r) * 1.0e6_real64)) == 0 when rounded to integer precision.

program conjugate_gradient
  use, intrinsic :: iso_fortran_env, only: real64, output_unit
  implicit none (type, external)

  integer, parameter :: n = 3
  real(real64) :: a(n, n), b(n), x(n), r(n), p(n), ap(n)
  real(real64) :: r_dot_r, r_dot_r_new, alpha, beta
  integer :: iter

  a = reshape([2.0_real64, -1.0_real64,  0.0_real64, &
              -1.0_real64,  2.0_real64, -1.0_real64, &
               0.0_real64, -1.0_real64,  2.0_real64], [n, n])
  b = [0.0_real64, 0.0_real64, 4.0_real64]
  x = 0.0_real64

  r = b - matmul(a, x)
  p = r
  r_dot_r = dot_product(r, r)

  do iter = 1, n + 2
    if (maxval(nint(abs(r) * 1.0e6_real64)) == 0) exit

    ap = matmul(a, p)
    alpha = r_dot_r / dot_product(p, ap)
    x = x + alpha * p
    r = r - alpha * ap
    r_dot_r_new = dot_product(r, r)

    if (maxval(nint(abs(r) * 1.0e6_real64)) == 0) exit

    beta = r_dot_r_new / r_dot_r
    p = r + beta * p
    r_dot_r = r_dot_r_new
  end do

  write(output_unit, '(a,*(1x,i0))') 'Solution x:', nint(x)
  write(output_unit, '(a,1x,l1)') 'Zero residual:', &
    (maxval(nint(abs(b - matmul(a, x)) * 1.0e6_real64)) == 0)

end program conjugate_gradient

! Output:
! Solution x: 1 2 3
! Zero residual: T
