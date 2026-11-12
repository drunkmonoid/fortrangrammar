program test_add
  use testdrive, only: new_unittest, unittest_type, error_type, check
  use math_lib, only: add
  implicit none (type, external)

  type(unittest_type) :: tests(1)
  tests(1) = new_unittest("test_addition", test_addition)
contains
  subroutine test_addition(error)
    type(error_type), allocatable, intent(out) :: error
    call check(error, add(2, 3) == 5, "2 + 3 == 5")
  end subroutine test_addition
end program test_add
