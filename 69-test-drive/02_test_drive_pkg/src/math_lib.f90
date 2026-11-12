module math_lib
  implicit none (type, external)
  private
  public :: add, mul
contains
  function add(a, b) result(res)
    integer, intent(in) :: a, b
    integer :: res
    res = a + b
  end function add

  function mul(a, b) result(res)
    integer, intent(in) :: a, b
    integer :: res
    res = a * b
  end function mul
end module math_lib
