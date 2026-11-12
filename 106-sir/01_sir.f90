! Explicit Euler integration of the compartmental SIR epidemic model:
!   S' = -beta * S * I / N
!   I' =  beta * S * I / N - gamma * I
!   R' =  gamma * I
! Total population N = S + I + R is conserved analytically at each step.

module sir_m
  use, intrinsic :: iso_fortran_env, only: real64
  implicit none (type, external)
  private
  public :: step_sir

contains

  pure subroutine step_sir(s, inf, rec, total_pop, beta, gamma, dt)
    real(real64), intent(inout) :: s, inf, rec
    real(real64), intent(in) :: total_pop, beta, gamma, dt
    real(real64) :: d_inf, d_rec

    d_inf = beta * s * inf / total_pop
    d_rec = gamma * inf

    s = s - dt * d_inf
    inf = inf + dt * (d_inf - d_rec)
    rec = rec + dt * d_rec
  end subroutine step_sir

end module sir_m

program sir_demo
  use, intrinsic :: iso_fortran_env, only: real64, output_unit
  use sir_m, only: step_sir
  implicit none (type, external)

  integer, parameter :: pop_n = 1000, n_steps = 5
  real(real64), parameter :: beta = 0.3_real64, gamma = 0.1_real64, dt = 0.5_real64
  real(real64) :: s, inf, rec
  integer :: step
  logical :: all_nonneg, sum_conserved

  s = 990.0_real64
  inf = 10.0_real64
  rec = 0.0_real64
  all_nonneg = .true.

  do step = 1, n_steps
    call step_sir(s, inf, rec, real(pop_n, real64), beta, gamma, dt)
    if (s < 0.0_real64 .or. inf < 0.0_real64 .or. rec < 0.0_real64) then
      all_nonneg = .false.
    end if
  end do

  sum_conserved = (nint(s + inf + rec) == pop_n) .and. all_nonneg
  write(output_unit, '(a,1x,l1)') 'nint(S + I + R) == N:', sum_conserved

end program sir_demo

! Output:
! nint(S + I + R) == N: T
