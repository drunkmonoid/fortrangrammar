! -----------------------------------------------------------------------------
! 07_kinds_module.f90 - the "working precision" idiom
!
! Run:  scripts/run.sh 03-intrinsic-types/07_kinds_module.f90
! -----------------------------------------------------------------------------
!
! Real-world codes define their kinds ONCE in a small module and use the
! names everywhere. Changing the whole program from double to quad then means
! editing one line.
!
!   * `wp` (working precision) is the conventional name; `dp` and `sp` are
!     also common.
!   * Every real literal carries the suffix: 1.0_wp.
!   * Intrinsics like real() and cmplx() get kind=wp.

module kinds
  use, intrinsic :: iso_fortran_env, only: sp => real32, dp => real64, &
                                           qp => real128, i4 => int32, &
                                           i8 => int64
  implicit none (type, external)
  private
  public :: sp, dp, qp, wp, i4, i8

  ! The one line to change:
  integer, parameter :: wp = dp
end module kinds

program kinds_module
  use kinds, only: wp, i8
  implicit none (type, external)

  real(wp), parameter :: pi = acos(-1.0_wp)
  real(wp) :: radius, area
  integer(i8) :: n

  radius = 2.5_wp
  area = pi * radius**2
  n = 10_i8**15

  print '(a, i0)', 'working precision kind: ', wp
  print '(a, g0)', 'pi   = ', pi
  print '(a, g0)', 'area = ', area
  print '(a, g0)', 'real(n, wp) / 3 = ', real(n, wp) / 3.0_wp

end program kinds_module

! Output:
! working precision kind: 8
! pi   = 3.1415926535897931
! area = 19.634954084936208
! real(n, wp) / 3 = 333333333333333.31
