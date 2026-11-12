! -----------------------------------------------------------------------------
! 01_newton.f90 - Newton-Raphson solver for a 2x2 nonlinear system
!
! Run:  scripts/run.sh 94-newton-systems/01_newton.f90
! -----------------------------------------------------------------------------
!
! Solves F(x, y) = (x**2 - 1, y**2 - 4) = (0, 0) using the analytic Jacobian:
!   J(x, y) = [ 2x   0 ]
!             [  0  2y ]
!
! Starting from (2, 3), 5 Newton iterations converge quadratically to (1, 2).
! If the Jacobian determinant vanishes (e.g., at (0, 0) or for a degenerate
! system), the linear solve sets stat = -1 and aborts cleanly.

module newton_2d_m
  use, intrinsic :: iso_fortran_env, only: real64
  implicit none (type, external)
  private
  public :: newton_solve

contains

  subroutine eval_system(v, f, jac)
    real(real64), intent(in) :: v(2)
    real(real64), intent(out) :: f(2), jac(2, 2)

    f(1) = v(1)**2 - 1.0_real64
    f(2) = v(2)**2 - 4.0_real64

    jac(1, 1) = 2.0_real64 * v(1)
    jac(1, 2) = 0.0_real64
    jac(2, 1) = 0.0_real64
    jac(2, 2) = 2.0_real64 * v(2)
  end subroutine eval_system

  subroutine solve_2x2(a, b, x, stat)
    real(real64), intent(in) :: a(2, 2), b(2)
    real(real64), intent(out) :: x(2)
    integer, intent(out) :: stat
    real(real64) :: det

    det = a(1, 1) * a(2, 2) - a(1, 2) * a(2, 1)
    if (abs(det) < 1.0e-14_real64) then
      stat = -1
      x = 0.0_real64
      return
    end if

    x(1) = (b(1) * a(2, 2) - a(1, 2) * b(2)) / det
    x(2) = (a(1, 1) * b(2) - b(1) * a(2, 1)) / det
    stat = 0
  end subroutine solve_2x2

  subroutine newton_solve(v0, n_iters, v, stat)
    real(real64), intent(in) :: v0(2)
    integer, intent(in) :: n_iters
    real(real64), intent(out) :: v(2)
    integer, intent(out) :: stat
    real(real64) :: f(2), jac(2, 2), delta(2)
    integer :: k

    v = v0
    stat = 0
    do k = 1, n_iters
      call eval_system(v, f, jac)
      call solve_2x2(jac, -f, delta, stat)
      if (stat /= 0) return
      v = v + delta
    end do
  end subroutine newton_solve

end module newton_2d_m

program newton_demo
  use, intrinsic :: iso_fortran_env, only: real64, output_unit
  use newton_2d_m, only: newton_solve
  implicit none (type, external)

  real(real64) :: root(2), bad_root(2)
  integer :: stat

  call newton_solve([2.0_real64, 3.0_real64], 5, root, stat)
  write(output_unit, '(a,1x,i0)') 'Converged stat:', stat
  write(output_unit, '(a,*(1x,i0))') 'Root nint:', nint(root)

  ! Starting at (0, 0) produces a singular Jacobian and sets stat = -1
  call newton_solve([0.0_real64, 0.0_real64], 5, bad_root, stat)
  write(output_unit, '(a,1x,i0)') 'Singular Jacobian stat:', stat

end program newton_demo

! Output:
! Converged stat: 0
! Root nint: 1 2
! Singular Jacobian stat: -1
