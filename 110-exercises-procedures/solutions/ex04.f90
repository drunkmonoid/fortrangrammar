! Exercise 14: module with private default, protected read-only state, and only: imports.

module ex14_m
  implicit none (type, external)
  private
  public :: tick_count, bump

  integer, protected :: tick_count = 0

contains

  subroutine bump(delta)
    integer, intent(in) :: delta
    if (delta > 0) tick_count = tick_count + delta
  end subroutine bump

end module ex14_m

program ex14_modules
  use, intrinsic :: iso_fortran_env, only: output_unit
  use ex14_m, only: tick_count, bump
  implicit none (type, external)

  call bump(3)
  call bump(-2)
  call bump(4)

  write(output_unit, '(a,1x,i0)') 'ticks:', tick_count

end program ex14_modules

! Output:
! ticks: 7
