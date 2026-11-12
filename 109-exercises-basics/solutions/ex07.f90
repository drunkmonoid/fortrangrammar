! Exercise 07: implied-do constructor combined with non-unit stride 2-D array slice.

program ex07_arrays_fundamentals
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none (type, external)

  integer :: a(4, 2), i

  a(:, 1) = [(i * i, i = 1, 4)]
  a(:, 2) = [(10 * i, i = 1, 4)]

  write(output_unit, '(a,1x,i0)') 'strided sum:', sum(a(1:4:2, :))

end program ex07_arrays_fundamentals

! Output:
! strided sum: 50
