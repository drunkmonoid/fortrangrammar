! -----------------------------------------------------------------------------
! 02_roots.f90 - bisection and Newton on x**2 - 2
!
! Run:  scripts/run.sh 45-quadrature/02_roots.f90
! -----------------------------------------------------------------------------
!
! The positive root is sqrt(2). Both methods stop on a tolerance or on a
! fixed budget (chapter 24's stat pattern, in miniature). The printed
! result is whether the residual is small, which does not depend on how
! many digits the compiler uses for sqrt.

program roots
  implicit none (type, external)

  real :: root
  integer :: stat

  call bisect(1.0, 2.0, 40, 1.0e-6, root, stat)
  print '(a, l1)', 'bisection: ', stat == 0 .and. abs(f(root)) < 1.0e-5

  call newton(1.0, 10, 1.0e-6, root, stat)
  print '(a, l1)', 'newton: ', stat == 0 .and. abs(f(root)) < 1.0e-5

contains

  pure real function f(x)
    real, intent(in) :: x
    f = x * x - 2.0
  end function f

  pure real function df(x)
    real, intent(in) :: x
    df = 2.0 * x
  end function df

  pure subroutine bisect(a0, b0, limit, tol, root, stat)
    real, intent(in) :: a0, b0, tol
    integer, intent(in) :: limit
    real, intent(out) :: root
    integer, intent(out) :: stat
    real :: a, b, mid
    integer :: k

    a = a0
    b = b0
    stat = 1
    root = a
    do k = 1, limit
      mid = 0.5 * (a + b)
      root = mid
      if (abs(f(mid)) < tol .or. abs(b - a) < tol) then
        stat = 0
        return
      end if
      if (f(a) * f(mid) <= 0.0) then
        b = mid
      else
        a = mid
      end if
    end do
  end subroutine bisect

  pure subroutine newton(x0, limit, tol, root, stat)
    real, intent(in) :: x0, tol
    integer, intent(in) :: limit
    real, intent(out) :: root
    integer, intent(out) :: stat
    real :: x
    integer :: k

    x = x0
    stat = 1
    root = x
    do k = 1, limit
      root = x
      if (abs(f(x)) < tol) then
        stat = 0
        return
      end if
      x = x - f(x) / df(x)
    end do
  end subroutine newton

end program roots

! Output:
! bisection: T
! newton: T
