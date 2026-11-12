! Exercise 12: generic interface overloading + abstract-interface procedure pointer.

module ex12_m
  use, intrinsic :: iso_fortran_env, only: real64
  implicit none (type, external)
  private
  public :: clamp, unary_i_fn, apply_twice, add_three

  interface clamp
    module procedure clamp_int
    module procedure clamp_real
  end interface clamp

  abstract interface
    pure integer function unary_i_fn(x)
      integer, intent(in) :: x
    end function unary_i_fn
  end interface

contains

  pure integer function add_three(x)
    integer, intent(in) :: x
    add_three = x + 3
  end function add_three

  pure integer function clamp_int(x, lo, hi)
    integer, intent(in) :: x, lo, hi
    clamp_int = max(lo, min(hi, x))
  end function clamp_int

  pure real(real64) function clamp_real(x, lo, hi)
    real(real64), intent(in) :: x, lo, hi
    clamp_real = max(lo, min(hi, x))
  end function clamp_real

  integer function apply_twice(fn, x)
    procedure(unary_i_fn) :: fn
    integer, intent(in) :: x
    apply_twice = fn(fn(x))
  end function apply_twice

end module ex12_m

program ex12_interfaces
  use, intrinsic :: iso_fortran_env, only: real64, output_unit
  use ex12_m, only: clamp, unary_i_fn, apply_twice, add_three
  implicit none (type, external)

  procedure(unary_i_fn), pointer :: fn_ptr => null()
  integer :: ci, doubled

  fn_ptr => add_three
  ci = clamp(15, 0, 10)
  doubled = apply_twice(fn_ptr, 4)

  write(output_unit, '(i0,1x,i0,1x,l1)') ci, doubled, &
    abs(clamp(1.5_real64, 0.0_real64, 1.0_real64) - 1.0_real64) < 1.0e-12_real64

end program ex12_interfaces

! Output:
! 10 10 T
