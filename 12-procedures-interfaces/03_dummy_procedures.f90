! -----------------------------------------------------------------------------
! 03_dummy_procedures.f90 - passing procedures as arguments
!
! Run:  scripts/run.sh 12-procedures-interfaces/03_dummy_procedures.f90
! -----------------------------------------------------------------------------
!
! A dummy procedure is declared with PROCEDURE(iface) (or an interface
! block). The actual argument can be:
!   * a module or external procedure,
!   * an INTERNAL procedure (F2008) - which can use its host's variables,
!     giving closure-like behaviour (parameters "captured" from the host),
!   * a procedure pointer,
!   * a specific intrinsic such as sin or sqrt (see 09_intrinsic_external).
!
! Note on internal procedures as actual arguments: gfortran implements
! them with a small code "trampoline" on the stack, so the linker warns
! that the executable needs an executable stack. The code is standard and
! works; pass module procedures where that matters.

module quadrature
  implicit none (type, external)

  abstract interface
    real function integrand(x)
      real, intent(in) :: x
    end function integrand
  end interface

contains

  real function simpson(f, a, b, n)
    procedure(integrand) :: f
    real, intent(in) :: a, b
    integer, intent(in) :: n          ! even number of intervals
    real :: h
    integer :: i

    h = (b - a) / n
    simpson = f(a) + f(b)
    do i = 1, n - 1
      simpson = simpson + merge(2.0, 4.0, mod(i, 2) == 0) * f(a + i * h)
    end do
    simpson = simpson * h / 3
  end function simpson

  real function parabola(x)
    real, intent(in) :: x
    parabola = x**2
  end function parabola

end module quadrature

program dummy_procedures
  use quadrature, only: simpson, parabola
  implicit none (type, external)

  real :: k
  integer :: power

  print '(a, f0.6)', 'int_0^1 x^2 dx      = ', simpson(parabola, 0.0, 1.0, 10)

  ! An internal procedure capturing host variables k and power.
  k = 3.0
  do power = 1, 3
    print '(a, i0, a, f0.6)', 'int_0^1 3 x^', power, ' dx    = ', simpson(scaled_power, 0.0, 1.0, 10)
  end do

contains

  real function scaled_power(x)
    real, intent(in) :: x
    scaled_power = k * x**power
  end function scaled_power

end program dummy_procedures

! Output:
! int_0^1 x^2 dx      = .333333
! int_0^1 3 x^1 dx    = 1.500000
! int_0^1 3 x^2 dx    = 1.000000
! int_0^1 3 x^3 dx    = .750000
