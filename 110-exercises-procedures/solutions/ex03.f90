! Exercise 13: elemental wrapper driving a pure recursive factorial over an array.

module ex13_m
  implicit none (type, external)
  private
  public :: fact_array

contains

  pure recursive integer function fact(n) result(ans)
    integer, intent(in) :: n
    if (n <= 1) then
      ans = 1
    else
      ans = n * fact(n - 1)
    end if
  end function fact

  elemental integer function fact_array(n)
    integer, intent(in) :: n
    fact_array = fact(n)
  end function fact_array

end module ex13_m

program ex13_attributes
  use, intrinsic :: iso_fortran_env, only: output_unit
  use ex13_m, only: fact_array
  implicit none (type, external)

  integer :: res(4)

  res = fact_array([0, 3, 4, 5])
  write(output_unit, '(4(i0, :, 1x))') res

end program ex13_attributes

! Output:
! 1 6 24 120
