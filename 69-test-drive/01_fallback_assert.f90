! -----------------------------------------------------------------------------
! 01_fallback_assert.f90 - dependency-free assertion module fallback
!
! Run:  scripts/run.sh 69-test-drive/01_fallback_assert.f90
! -----------------------------------------------------------------------------

module test_fallback_m
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none (type, external)
  private
  public :: test_runner_t

  type :: test_runner_t
    integer :: passed = 0
    integer :: failed = 0
  contains
    procedure :: check => runner_check
    procedure :: report => runner_report
  end type test_runner_t

contains

  subroutine runner_check(self, condition, test_name)
    class(test_runner_t), intent(inout) :: self
    logical, intent(in) :: condition
    character(len=*), intent(in) :: test_name

    if (condition) then
      self%passed = self%passed + 1
    else
      self%failed = self%failed + 1
      write(output_unit, '(2a)') 'FAIL: ', test_name
    end if
  end subroutine runner_check

  subroutine runner_report(self)
    class(test_runner_t), intent(in) :: self

    write(output_unit, '(a,i0,a,i0,a)') 'Test results: ', self%passed, ' passed, ', &
      self%failed, ' failed'
    if (self%failed /= 0) then
      error stop "Tests failed"
    end if
  end subroutine runner_report

end module test_fallback_m

program fallback_demo
  use test_fallback_m, only: test_runner_t
  implicit none (type, external)

  type(test_runner_t) :: runner

  ! Execute unit tests
  call runner%check(2 + 3 == 5, "addition")
  call runner%check(4 * 5 == 20, "multiplication")
  call runner%check(trim("hello "//"world") == "hello world", "concatenation")

  call runner%report()
end program fallback_demo

! Output:
! Test results: 3 passed, 0 failed
