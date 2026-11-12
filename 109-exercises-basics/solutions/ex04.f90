! Exercise 04: enum, bind(c) paired with an integer, parameter weight lookup table.

program ex04_declarations
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none (type, external)

  enum, bind(c)
    enumerator :: colour_red = 1, colour_green = 2, colour_blue = 3
  end enum

  integer, parameter :: weights(3) = [100, 200, 300]
  integer :: checksum

  checksum = weights(colour_red) + weights(colour_green) + weights(colour_blue)
  write(output_unit, '(a,1x,i0)') 'checksum:', checksum

end program ex04_declarations

! Output:
! checksum: 600
