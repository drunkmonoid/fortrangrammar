! -----------------------------------------------------------------------------
! 07_program_units.f90 - the kinds of program unit, all in one file
!
! Run:  scripts/run.sh 01-getting-started/07_program_units.f90
! -----------------------------------------------------------------------------
!
! A Fortran program is built from program units:
!
!   main program        exactly one per executable           (this file, below)
!   module              shared types, data and procedures    (chapter 14)
!   submodule           implementation half of a module      (chapter 15)
!   external subprogram a stand-alone subroutine or function (below)
!   block data          obsolescent since F2018, not covered
!
! One source file may contain several program units. A module must be
! compiled before any unit that USEs it, so it comes first in the file.
! Compiling a module produces a .mod file (here in build/.../).

! --- Module ----------------------------------------------------------------
module greetings
  implicit none (type, external)
  private            ! everything is hidden unless listed as public
  public :: greet

contains

  subroutine greet(name)
    character(len=*), intent(in) :: name

    print '(a)', 'Hello, ' // name // '!'
  end subroutine greet

end module greetings

! --- External function -----------------------------------------------------
! Legal, but callers only get type checking through an interface block.
! Prefer module procedures.
function square(x) result(y)
  implicit none (type, external)
  real, intent(in) :: x
  real :: y

  y = x * x
end function square

! --- Main program ----------------------------------------------------------
program program_units
  use greetings, only: greet
  implicit none (type, external)

  interface
    function square(x) result(y)
      implicit none
      real, intent(in) :: x
      real :: y
    end function square
  end interface

  call greet('modern Fortran')
  print '(a, f0.1)', 'square(3.0) = ', square(3.0)

end program program_units

! Output:
! Hello, modern Fortran!
! square(3.0) = 9.0
