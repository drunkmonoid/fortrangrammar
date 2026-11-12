! Exercise 20: unlimited polymorphic box (class(*)) wrapper + select type tally.

module ex20_m
  implicit none (type, external)
  private
  public :: box_t

  type :: box_t
    class(*), allocatable :: item
  end type box_t

end module ex20_m

program ex20_unlimited
  use, intrinsic :: iso_fortran_env, only: real64, output_unit
  use ex20_m, only: box_t
  implicit none (type, external)

  type(box_t) :: items(4)
  integer :: i, n_int, n_real, n_char

  items(1)%item = 7
  items(2)%item = 2.5_real64
  items(3)%item = 'hi'
  items(4)%item = 99

  n_int = 0
  n_real = 0
  n_char = 0
  do i = 1, size(items)
    select type (v => items(i)%item)
    type is (integer)
      n_int = n_int + 1
    type is (real(real64))
      n_real = n_real + 1
    type is (character(len=*))
      n_char = n_char + 1
    end select
  end do

  write(output_unit, '(a,1x,i0,1x,i0,1x,i0)') 'int real char:', n_int, n_real, n_char

end program ex20_unlimited

! Output:
! int real char: 2 1 1
