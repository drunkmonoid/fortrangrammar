! -----------------------------------------------------------------------------
! 01_lcg.f90 - Linear congruential generator and quarter-circle Monte Carlo
!
! Run:  scripts/run.sh 97-lcg/01_lcg.f90
! -----------------------------------------------------------------------------
!
! Implements x_{n+1} = mod(a * x_n + c, m) using int64 arithmetic:
!   1. A toy modulus m = 16, a = 5, c = 3 satisfies the Hull-Dobell theorem
!      and is verified to have full period 16.
!   2. A 16-bit full-period LCG (m = 65536, a = 25173, c = 13849, seed = 1)
!      generates 1000 points in [0, 1)^2 to count hits inside the quarter circle
!      x**2 + y**2 <= 1.
!
! This is a deterministic explicit generator, distinct from Fortran's intrinsic
! random_number (chapter 24, phase 48).

module lcg_m
  use, intrinsic :: iso_fortran_env, only: int64, real64
  implicit none (type, external)
  private
  public :: lcg_t, lcg_period

  type :: lcg_t
    integer(int64) :: state = 1_int64
    integer(int64) :: a = 25173_int64
    integer(int64) :: c = 13849_int64
    integer(int64) :: m = 65536_int64
  contains
    procedure :: next_int
    procedure :: next_unit
  end type lcg_t

contains

  function next_int(self) result(val)
    class(lcg_t), intent(inout) :: self
    integer(int64) :: val

    self%state = mod(self%a * self%state + self%c, self%m)
    val = self%state
  end function next_int

  function next_unit(self) result(u)
    class(lcg_t), intent(inout) :: self
    real(real64) :: u

    u = real(self%next_int(), kind=real64) / real(self%m, kind=real64)
  end function next_unit

  function lcg_period(a, c, m, seed) result(period)
    integer(int64), intent(in) :: a, c, m, seed
    integer(int64) :: period, cur

    cur = seed
    period = 0_int64
    do
      cur = mod(a * cur + c, m)
      period = period + 1_int64
      if (cur == seed .or. period > m) exit
    end do
  end function lcg_period

end module lcg_m

program lcg_demo
  use, intrinsic :: iso_fortran_env, only: int64, real64, output_unit
  use lcg_m, only: lcg_t, lcg_period
  implicit none (type, external)

  integer, parameter :: n_points = 1000
  type(lcg_t) :: rng
  integer(int64) :: toy_period
  real(real64) :: x, y
  integer :: i, inside

  ! Verify full period on toy modulus m = 16
  toy_period = lcg_period(5_int64, 3_int64, 16_int64, 0_int64)

  rng = lcg_t(state=1_int64)
  inside = 0
  do i = 1, n_points
    x = rng%next_unit()
    y = rng%next_unit()
    if (x * x + y * y <= 1.0_real64) inside = inside + 1
  end do

  write(output_unit, '(a,1x,i0)') 'Toy period (m=16):', toy_period
  write(output_unit, '(a,1x,i0)') 'Quarter-circle hits (of 1000):', inside

end program lcg_demo

! Output:
! Toy period (m=16): 16
! Quarter-circle hits (of 1000): 776
