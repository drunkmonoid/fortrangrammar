! Exercise 11: optional keyword argument with present() and intent(out) status flag.

module ex11_m
  implicit none (type, external)
  private
  public :: bounded_div

contains

  subroutine bounded_div(num, denom, quot, ok)
    integer, intent(in) :: num
    integer, intent(in), optional :: denom
    integer, intent(out) :: quot
    logical, intent(out) :: ok
    integer :: d

    if (present(denom)) then
      d = denom
    else
      d = 1
    end if

    if (d == 0) then
      quot = 0
      ok = .false.
    else
      quot = num / d
      ok = .true.
    end if
  end subroutine bounded_div

end module ex11_m

program ex11_procedures_basics
  use, intrinsic :: iso_fortran_env, only: output_unit
  use ex11_m, only: bounded_div
  implicit none (type, external)

  integer :: q1, q2
  logical :: ok1, ok2

  call bounded_div(12, quot=q1, ok=ok1)
  call bounded_div(12, denom=0, quot=q2, ok=ok2)

  write(output_unit, '(i0,1x,l1,1x,i0,1x,l1)') q1, ok1, q2, ok2

end program ex11_procedures_basics

! Output:
! 12 T 0 F
