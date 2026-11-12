! Exercise 17: kind-parameterized derived type instantiated at int32 and int64.

module ex17_m
  use, intrinsic :: iso_fortran_env, only: int32, int64
  implicit none (type, external)
  private
  public :: pair_t

  type :: pair_t(k)
    integer, kind :: k = int32
    integer(k) :: lo
    integer(k) :: hi
  end type pair_t

end module ex17_m

program ex17_pdt
  use, intrinsic :: iso_fortran_env, only: int32, int64, output_unit
  use ex17_m, only: pair_t
  implicit none (type, external)

  type(pair_t(int32)) :: p32
  type(pair_t(int64)) :: p64

  p32%lo = 10_int32
  p32%hi = 20_int32
  p64%lo = 10000000000_int64
  p64%hi = 20000000000_int64

  write(output_unit, '(i0,1x,i0)') p32%lo + p32%hi, p64%lo + p64%hi

end program ex17_pdt

! Output:
! 30 30000000000
