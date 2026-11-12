program test_mul
  use testdrive, only: new_unittest, unittest_type, error_type, check
  use math_lib, only: mul
  implicit none (type, external)

  type(unittest_type) :: tests(1)
  tests(1) = new_unittest("test_multiplication", test_multiplication)
contains
  subroutine test_multiplication(error)
    type(error_type), allocatable, intent(out) :: error
    call check(error, mul(4, 5) == 20, "4 * 5 == 20")
  end subroutine test_multiplication
end program test_mul
