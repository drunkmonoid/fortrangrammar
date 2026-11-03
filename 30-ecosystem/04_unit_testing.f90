! -----------------------------------------------------------------------------
! 04_unit_testing.f90 - a dependency-free unit-test pattern
!
! Run:  scripts/run.sh 30-ecosystem/04_unit_testing.f90
! -----------------------------------------------------------------------------
!
! Real projects use a framework:
!   * test-drive   (fortran-lang) - tiny, pure Fortran, integrates with fpm,
!                  CMake and Meson; the de-facto default for new projects
!   * pFUnit       (NASA) - JUnit-style, preprocessor annotations (@test),
!                  MPI support; common in large HPC codes
!   * veggies / garden - BDD-style specifications
!   * Julienne     - assertions for coarray/parallel codes
!
! They all share the shape shown here: test procedures that report
! failures, a registry, a driver that counts results and exits with a
! nonzero status if anything failed (so CI and ctest/fpm test notice).

module testing
  implicit none (type, external)
  private
  public :: check, report

  integer :: passed = 0, failed = 0

contains

  subroutine check(condition, name)
    logical, intent(in) :: condition
    character(len=*), intent(in) :: name
    if (condition) then
      passed = passed + 1
    else
      failed = failed + 1
      print '(2a)', '  FAILED: ', name
    end if
  end subroutine check

  subroutine report()
    print '(a, i0, a, i0, a)', 'tests: ', passed, ' passed, ', failed, ' failed'
    if (failed > 0) error stop 1
  end subroutine report

end module testing

module under_test
  implicit none (type, external)
contains
  pure integer function gcd(a, b)
    integer, intent(in) :: a, b
    integer :: x, y, t
    x = abs(a); y = abs(b)
    do while (y /= 0)
      t = mod(x, y); x = y; y = t
    end do
    gcd = x
  end function gcd
end module under_test

program unit_testing
  use testing, only: check, report
  use under_test, only: gcd
  implicit none (type, external)

  call check(gcd(12, 18) == 6, 'gcd(12, 18)')
  call check(gcd(7, 13) == 1, 'coprime')
  call check(gcd(0, 5) == 5, 'zero argument')
  call check(gcd(-4, 6) == 2, 'negative argument')
  call report()

end program unit_testing

! Output:
! tests: 4 passed, 0 failed
