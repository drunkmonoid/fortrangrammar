! -----------------------------------------------------------------------------
! 09_intrinsic_as_argument.f90 - INTRINSIC and EXTERNAL attributes
!
! Run:  scripts/run.sh 12-procedures-interfaces/09_intrinsic_as_argument.f90
! -----------------------------------------------------------------------------
!
!   intrinsic :: sin, cos       "these names mean the intrinsics" - needed
!                               only where a local name could hide them,
!                               but harmless and self-documenting
!   external :: legacy_fn       "this is an external procedure" (implicit
!                               interface - avoid; prefer an interface block
!                               or procedure(iface) :: legacy_fn)
!
! A SPECIFIC intrinsic function may be passed as an actual argument when its
! interface matches the dummy: sin, cos, sqrt, exp, abs, ... for default
! real. Generic-only intrinsics (e.g. max, min, int with kind=) cannot be
! passed; wrap them in a small module function instead.

module table
  implicit none (type, external)

  abstract interface
    real function real_fn(x)
      real, intent(in) :: x
    end function real_fn
  end interface

contains

  subroutine tabulate(name, f)
    character(len=*), intent(in) :: name
    procedure(real_fn) :: f
    integer :: i

    write (*, '(a6, ":")', advance='no') name
    do i = 0, 4
      write (*, '(f8.4)', advance='no') f(0.5 * i)
    end do
    print '(a)', ''
  end subroutine tabulate

  real function clamp01(x)          ! wrapper around generic min/max
    real, intent(in) :: x
    clamp01 = min(max(x, 0.0), 1.0)
  end function clamp01

end module table

program intrinsic_as_argument
  use table, only: tabulate, clamp01
  implicit none (type, external)

  intrinsic :: sin, sqrt, exp

  call tabulate('sin', sin)
  call tabulate('sqrt', sqrt)
  call tabulate('exp', exp)
  call tabulate('clamp', clamp01)

end program intrinsic_as_argument

! Output:
!    sin:  0.0000  0.4794  0.8415  0.9975  0.9093
!   sqrt:  0.0000  0.7071  1.0000  1.2247  1.4142
!    exp:  1.0000  1.6487  2.7183  4.4817  7.3891
!  clamp:  0.0000  0.5000  1.0000  1.0000  1.0000
