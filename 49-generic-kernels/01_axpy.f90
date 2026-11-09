! -----------------------------------------------------------------------------
! 01_axpy.f90 - one axpy body for real32, real64 and real128
!
! Run:  scripts/run.sh 49-generic-kernels/01_axpy.f90
! -----------------------------------------------------------------------------
!
! The three module procedures differ in the kind of their arguments. The
! assignment is axpy_body.inc, included into each of them. include searches
! relative to this source file.
!
!   y = [1, 2, 3], a = 2, x = [1, 1, 1]  =>  y = [3, 4, 5]
!
! A generic interface lets the call be axpy(...) for every kind.

module axpy_m
  use, intrinsic :: iso_fortran_env, only: real32, real64, real128
  implicit none (type, external)
  private
  public :: axpy
  interface axpy
    module procedure axpy32, axpy64, axpy128
  end interface axpy
contains
  subroutine axpy32(a, x, y)
    real(real32), intent(in) :: a
    real(real32), intent(in) :: x(:)
    real(real32), intent(inout) :: y(:)
    include 'axpy_body.inc'
  end subroutine axpy32

  subroutine axpy64(a, x, y)
    real(real64), intent(in) :: a
    real(real64), intent(in) :: x(:)
    real(real64), intent(inout) :: y(:)
    include 'axpy_body.inc'
  end subroutine axpy64

  subroutine axpy128(a, x, y)
    real(real128), intent(in) :: a
    real(real128), intent(in) :: x(:)
    real(real128), intent(inout) :: y(:)
    include 'axpy_body.inc'
  end subroutine axpy128
end module axpy_m

program axpy_demo
  use, intrinsic :: iso_fortran_env, only: real32, real64, real128
  use axpy_m, only: axpy
  implicit none (type, external)

  real(real32) :: y32(3)
  real(real64) :: y64(3)
  real(real128) :: y128(3)

  y32 = [1, 2, 3]
  y64 = [1, 2, 3]
  y128 = [1, 2, 3]
  call axpy(2.0_real32, [1.0_real32, 1.0_real32, 1.0_real32], y32)
  call axpy(2.0_real64, [1.0_real64, 1.0_real64, 1.0_real64], y64)
  call axpy(2.0_real128, [1.0_real128, 1.0_real128, 1.0_real128], y128)

  print '(a, 3(1x, i0))', 'real32 =', nint(y32)
  print '(a, 3(1x, i0))', 'real64 =', nint(y64)
  print '(a, 3(1x, i0))', 'real128 =', nint(y128)

end program axpy_demo

! Output:
! real32 = 3 4 5
! real64 = 3 4 5
! real128 = 3 4 5
