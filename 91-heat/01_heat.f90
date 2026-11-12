! -----------------------------------------------------------------------------
! 01_heat.f90 - Explicit 1-D heat equation (FTCS) on linear initial data
!
! Run:  scripts/run.sh 91-heat/01_heat.f90
! -----------------------------------------------------------------------------
!
! Discretises u_t = u_xx using Forward-Time Centred-Space (FTCS):
!   u_new(i) = u(i) + r * (u(i - 1) - 2 * u(i) + u(i + 1))
! where r = dt / dx**2.
!
! Stability limit (von Neumann): dt / dx**2 <= 1 / 2.
! We choose dx = 1.0 and dt = 0.25 (r = 0.25 <= 0.5) and never run an
! unstable step. Because the initial profile u(x) = x is linear, its second
! difference vanishes identically and the steady state remains unchanged.

program heat_ftcs
  use, intrinsic :: iso_fortran_env, only: real64, output_unit
  implicit none (type, external)

  integer, parameter :: n_interior = 3
  real(real64), parameter :: dx = 1.0_real64
  real(real64), parameter :: dt = 0.25_real64
  real(real64), parameter :: r = dt / (dx * dx)

  real(real64) :: u(0:n_interior + 1), u_new(0:n_interior + 1)
  integer :: i

  ! Linear initial and boundary profile: u(i) = i
  do i = 0, n_interior + 1
    u(i) = real(i, kind=real64)
  end do
  u_new = u

  ! Single FTCS step for interior points
  do i = 1, n_interior
    u_new(i) = u(i) + r * (u(i - 1) - 2.0_real64 * u(i) + u(i + 1))
  end do

  write(output_unit, '(a,*(1x,i0))') 'Interior after step:', nint(u_new(1:n_interior))

end program heat_ftcs

! Output:
! Interior after step: 1 2 3
