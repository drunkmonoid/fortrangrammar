! -----------------------------------------------------------------------------
! 02_program_anatomy.f90 - the parts of a program unit and their order
!
! Run:  scripts/run.sh 01-getting-started/02_program_anatomy.f90
! -----------------------------------------------------------------------------
!
! Every program unit (main program, module, subprogram) is laid out as:
!
!   1. heading statement          program / module / subroutine / function
!   2. USE statements             access modules
!   3. IMPORT statements          (interface bodies and contained scopes only)
!   4. IMPLICIT statements        normally just IMPLICIT NONE
!   5. declarations               types, variables, constants, interfaces
!   6. executable statements      the actual work
!   7. CONTAINS + subprograms     internal (or module) procedures
!   8. END statement
!
! Parts 2-5 form the "specification part"; part 6 is the "execution part".
! Every declaration must come before the first executable statement (use a
! BLOCK construct, chapter 06, to declare variables in the middle of code).

program program_anatomy
  ! --- 2. USE statements --------------------------------------------------
  use, intrinsic :: iso_fortran_env, only: output_unit

  ! --- 4. IMPLICIT statement ----------------------------------------------
  implicit none (type, external)

  ! --- 5. declarations ----------------------------------------------------
  ! A named constant: its value is fixed at compile time.
  real, parameter :: pi = 4.0 * atan(1.0)
  ! Ordinary variables.
  integer :: times
  real :: radius

  ! --- 6. executable statements -------------------------------------------
  times = 2
  radius = 1.5

  call greet(times)
  write (output_unit, '(a, f0.4)') 'circle area = ', area(radius)

  ! --- 7. internal subprograms --------------------------------------------
  ! Internal procedures can see the host's variables ("host association"),
  ! e.g. area() below uses pi without declaring it.
contains

  subroutine greet(n)
    integer, intent(in) :: n
    integer :: i

    do i = 1, n
      print '(a, i0)', 'hello #', i
    end do
  end subroutine greet

  real function area(r)
    real, intent(in) :: r

    area = pi * r**2
  end function area

  ! --- 8. END statement ---------------------------------------------------
end program program_anatomy

! Output:
! hello #1
! hello #2
! circle area = 7.0686
