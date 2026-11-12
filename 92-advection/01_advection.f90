! -----------------------------------------------------------------------------
! 01_advection.f90 - 1-D periodic upwind advection at Courant number C = 1
!
! Run:  scripts/run.sh 92-advection/01_advection.f90
! -----------------------------------------------------------------------------
!
! Solves u_t + u_x = 0 on a periodic 8-cell grid using first-order upwind:
!   u_new(i) = u(i) - C * (u(i) - u(left(i)))
! where C = dt / dx is the Courant number.
!
! Choosing dx = 1.0 and dt = 1.0 sets C = 1.0, eliminating numerical diffusion
! and shifting the block of ones cleanly by exactly 1 cell per time step.

program advection_upwind
  use, intrinsic :: iso_fortran_env, only: real64, output_unit
  implicit none (type, external)

  integer, parameter :: n = 8, n_steps = 3
  real(real64), parameter :: dx = 1.0_real64
  real(real64), parameter :: dt = 1.0_real64
  real(real64), parameter :: courant = dt / dx

  real(real64) :: u(n), u_new(n)
  integer :: step, i, left, checksum

  ! Initial square pulse: cells 2..4 are 1, others 0
  u = [0.0_real64, 1.0_real64, 1.0_real64, 1.0_real64, &
       0.0_real64, 0.0_real64, 0.0_real64, 0.0_real64]

  do step = 1, n_steps
    do i = 1, n
      left = merge(n, i - 1, i == 1)
      u_new(i) = u(i) - courant * (u(i) - u(left))
    end do
    u = u_new
  end do

  checksum = sum([(i * nint(u(i)), i = 1, n)])

  write(output_unit, '(a,*(1x,i0))') 'Grid after 3 steps:', nint(u)
  write(output_unit, '(a,1x,i0)') 'Position checksum:', checksum

end program advection_upwind

! Output:
! Grid after 3 steps: 0 0 0 0 1 1 1 0
! Position checksum: 18
