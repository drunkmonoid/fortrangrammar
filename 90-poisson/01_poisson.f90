! -----------------------------------------------------------------------------
! 01_poisson.f90 - 1-D Poisson equation solved with the Thomas algorithm
!
! Run:  scripts/run.sh 90-poisson/01_poisson.f90
! -----------------------------------------------------------------------------
!
! Solves -u''(x) = 1 on (0, 1) with Dirichlet boundaries u(0) = u(1) = 0
! using n = 3 interior points at x = 0.25, 0.50, 0.75 (h = 1/4 = 0.25).
!
! Second-order finite differences yield:
!   (-u_{i-1} + 2 u_i - u_{i+1}) / h**2 = 1
!
! Exact solution: u(x) = x * (1 - x) / 2, giving [3/32, 4/32, 3/32].
! Because u is quadratic, the second-difference truncation error vanishes.
! We scale by 32 before printing nint(32 * u) so the expected output is
! the exact integer vector: 3 4 3.

module poisson_m
  use, intrinsic :: iso_fortran_env, only: real64
  implicit none (type, external)
  private
  public :: thomas_solve

contains

  subroutine thomas_solve(a, b, c, d, x)
    ! Solve tridiagonal system A x = d where:
    !   a(2:n) = subdiagonal, b(1:n) = diagonal, c(1:n-1) = superdiagonal
    real(real64), intent(in) :: a(:), b(:), c(:), d(:)
    real(real64), intent(out) :: x(:)
    real(real64) :: c_prime(size(b)), d_prime(size(b)), m
    integer :: i, n

    n = size(b)
    c_prime(1) = c(1) / b(1)
    d_prime(1) = d(1) / b(1)

    ! Forward sweep
    do i = 2, n
      m = 1.0_real64 / (b(i) - a(i) * c_prime(i - 1))
      if (i < n) c_prime(i) = c(i) * m
      d_prime(i) = (d(i) - a(i) * d_prime(i - 1)) * m
    end do

    ! Back substitution
    x(n) = d_prime(n)
    do i = n - 1, 1, -1
      x(i) = d_prime(i) - c_prime(i) * x(i + 1)
    end do
  end subroutine thomas_solve

end module poisson_m

program poisson_demo
  use, intrinsic :: iso_fortran_env, only: real64, output_unit
  use poisson_m, only: thomas_solve
  implicit none (type, external)

  integer, parameter :: n = 3
  real(real64), parameter :: h = 0.25_real64
  real(real64), parameter :: scale_factor = 32.0_real64
  real(real64) :: a(n), b(n), c(n), rhs(n), u(n), exact(n)
  integer :: i

  a = -1.0_real64
  a(1) = 0.0_real64
  b = 2.0_real64
  c = -1.0_real64
  c(n) = 0.0_real64
  rhs = h * h

  call thomas_solve(a, b, c, rhs, u)

  do i = 1, n
    exact(i) = (i * h) * (1.0_real64 - i * h) * 0.5_real64
  end do

  write(output_unit, '(a,*(1x,i0))') 'Scaled u (x32):', nint(scale_factor * u)
  write(output_unit, '(a,1x,l1)') 'Matches exact:', all(abs(u - exact) < 1.0e-14_real64)

end program poisson_demo

! Output:
! Scaled u (x32): 3 4 3
! Matches exact: T
