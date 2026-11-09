! -----------------------------------------------------------------------------
! demo.f90 - stdlib calls, and the language feature each one stands in for
!
! Build: scripts/run.sh 41-stdlib/01_calls/
! -----------------------------------------------------------------------------
!
! solve    -> dgesv, chapter 43
! norm     -> norm2, chapter 09
! mean     -> sum / size, chapter 09
! optval   -> present, chapter 11
! to_string -> internal-file write, chapter 22
! logger   -> a unit you opened, chapter 23

program stdlib_calls
  use, intrinsic :: iso_fortran_env, only: real64
  use stdlib_linalg, only: solve, norm
  use stdlib_stats, only: mean
  use stdlib_optval, only: optval
  use stdlib_strings, only: to_string
  use stdlib_logger, only: logger_type
  implicit none (type, external)

  real(real64) :: a(3, 3), b(3), x(3)
  real(real64) :: samples(3)
  type(logger_type) :: logger

  ! The same 3x3 system as stdlib's solve example. Column-major reshape
  ! lists the first row across, so transpose makes those the rows.
  ! The solution is exactly 5, 3, -2.
  a = transpose(reshape([4.0_real64, 3.0_real64, 2.0_real64, &
                         -2.0_real64, 2.0_real64, 3.0_real64, &
                         3.0_real64, -5.0_real64, 2.0_real64], [3, 3]))
  b = [25.0_real64, -10.0_real64, -4.0_real64]
  x = solve(a, b)
  print '(a, 3(i0, 1x))', 'solve = ', nint(x)

  print '(a, i0)', 'norm = ', nint(norm([3.0_real64, 4.0_real64], 2))

  samples = [1.0_real64, 2.0_real64, 3.0_real64]
  print '(a, i0)', 'mean = ', nint(mean(samples))

  print '(a, i0)', 'optval default = ', shown()
  print '(a, i0)', 'optval given = ', shown(4)
  print '(a)', 'text = ' // trim(to_string(5))
  print '(a, i0)', 'log units = ', logger%log_units_assigned()

contains

  integer function shown(preferred) result(choice)
    integer, intent(in), optional :: preferred
    choice = optval(preferred, 0)
  end function shown

end program stdlib_calls
