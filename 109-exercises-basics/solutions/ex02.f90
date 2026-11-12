! Exercise 02: continuation lines (&), semicolon statements (;), and non-reserved name 'sum'.

program ex02_lexical
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none (type, external)

  integer :: a, b, sum

  a = 10; b = 20
  sum = a + &
        b * 2

  write(output_unit, '(a,1x,i0)') 'sum:', sum

end program ex02_lexical

! Output:
! sum: 50
