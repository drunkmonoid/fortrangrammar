! Exercise 09: reshape with order=[2, 1] combined with pack and logical mask.

program ex09_array_intrinsics
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none (type, external)

  integer :: mat(2, 3), i
  integer, allocatable :: evens(:)

  mat = reshape([(i, i = 1, 6)], [2, 3], order=[2, 1])
  evens = pack(transpose(mat), mod(transpose(mat), 2) == 0)

  write(output_unit, '(3(i0, :, 1x))') evens

end program ex09_array_intrinsics

! Output:
! 2 4 6
