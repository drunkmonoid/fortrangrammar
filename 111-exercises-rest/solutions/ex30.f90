! Exercise 30: an assert, and the compiler's own version string.
program ex30
  use, intrinsic :: iso_fortran_env, only: compiler_version
  implicit none (type, external)

  call assert(2 + 2 == 4)
  print '(a, l1)', 'known compiler: ', len(compiler_version()) > 0

contains

  subroutine assert(cond)
    logical, intent(in) :: cond
    if (.not. cond) error stop 'assert'
  end subroutine assert

end program ex30

! Output:
! known compiler: T
