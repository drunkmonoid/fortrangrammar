! Exercise 05: guarded division combined with merge and negative integer division.

program ex05_expressions
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none (type, external)

  integer :: num, denom, q, r, tag

  num = -7
  denom = 2
  if (denom /= 0) then
    q = num / denom
    r = modulo(num, denom)
  else
    q = 0
    r = 0
  end if
  tag = merge(1, -1, q == -3 .and. r == 1)

  write(output_unit, '(i0,1x,i0,1x,i0)') q, r, tag

end program ex05_expressions

! Output:
! -3 1 1
