! -----------------------------------------------------------------------------
! 01_variates.f90 - Box-Muller, a discrete sampler, two seeds, a Monte Carlo integral
!
! Run:  scripts/run.sh 48-random-variates/01_variates.f90
! -----------------------------------------------------------------------------
!
! The stream is compiler-dependent, so the draws themselves are not
! printed. The seed values 7 and 11 are fixed; only the checks are.

program random_variates
  implicit none (type, external)

  integer, parameter :: n_normal = 4000
  integer, parameter :: n_discrete = 2000
  integer, parameter :: n_integral = 20000
  real :: normal(n_normal), mean, u, estimate
  integer :: i, low, high
  real :: first, second

  call random_init(repeatable=.true., image_distinct=.true.)

  call reseed(7)
  do i = 1, n_normal
    normal(i) = box_muller()
  end do
  mean = sum(normal) / real(n_normal)
  print '(a, l1)', 'normals finite: ', all(normal == normal)
  print '(a, l1)', 'normal mean near zero: ', abs(mean) < 0.1

  call reseed(7)
  low = 0
  high = 0
  do i = 1, n_discrete
    call random_number(u)
    if (u < 0.5) then
      low = low + 1
    else
      high = high + 1
    end if
  end do
  print '(a, l1)', 'both bins: ', low > 0 .and. high > 0
  print '(a, l1)', 'half: ', abs(real(low) / real(n_discrete) - 0.5) < 0.05

  call reseed(7)
  call random_number(first)
  call reseed(11)
  call random_number(second)
  print '(a, l1)', 'streams differ: ', first /= second

  call reseed(7)
  estimate = 0.0
  do i = 1, n_integral
    call random_number(u)
    estimate = estimate + u
  end do
  estimate = estimate / real(n_integral)
  print '(a, l1)', 'integral near one half: ', abs(estimate - 0.5) < 0.02

contains

  subroutine reseed(tag)
    integer, intent(in) :: tag
    integer :: n
    integer, allocatable :: seed(:)
    call random_seed(size=n)
    allocate(seed(n))
    seed = tag
    call random_seed(put=seed)
  end subroutine reseed

  ! Two uniforms on (0, 1) become one standard normal. A zero is rejected
  ! because log(0) is not a number.
  real function box_muller() result(z)
    real :: u, v
    real, parameter :: pi = acos(-1.0)
    do
      call random_number(u)
      if (u > 0.0) exit
    end do
    call random_number(v)
    z = sqrt(-2.0 * log(u)) * cos(2.0 * pi * v)
  end function box_muller

end program random_variates

! Output:
! normals finite: T
! normal mean near zero: T
! both bins: T
! half: T
! streams differ: T
! integral near one half: T
