program test_interp
  use, intrinsic :: iso_fortran_env, only: real64, output_unit
  use interp1d_m, only: interp1d_t
  implicit none (type, external)

  type(interp1d_t) :: interp
  real(real64) :: x(4), y(4), val
  integer :: stat
  integer :: passed = 0, failed = 0

  x = [0.0_real64, 1.0_real64, 2.0_real64, 4.0_real64]
  y = [0.0_real64, 10.0_real64, 20.0_real64, 40.0_real64]

  call interp%init(x, y, stat)
  call check(stat == 0, "init successful")

  val = interp%eval(0.5_real64, stat)
  call check(stat == 0 .and. abs(val - 5.0_real64) < 1.0e-12_real64, "eval 0.5")

  val = interp%eval(1.5_real64, stat)
  call check(stat == 0 .and. abs(val - 15.0_real64) < 1.0e-12_real64, "eval 1.5")

  val = interp%eval(3.0_real64, stat)
  call check(stat == 0 .and. abs(val - 30.0_real64) < 1.0e-12_real64, "eval 3.0")

  ! Out of bounds check
  val = interp%eval(5.0_real64, stat)
  call check(stat /= 0, "out-of-bounds error")

  call interp%destroy()

  write(output_unit, '(a,i0,a,i0,a)') 'Fortran tests: ', passed, ' passed, ', failed, ' failed'
  if (failed /= 0) error stop "Tests failed"

contains

  subroutine check(cond, msg)
    logical, intent(in) :: cond
    character(len=*), intent(in) :: msg
    if (cond) then
      passed = passed + 1
    else
      failed = failed + 1
      write(output_unit, '(2a)') 'FAIL: ', msg
    end if
  end subroutine check

end program test_interp
