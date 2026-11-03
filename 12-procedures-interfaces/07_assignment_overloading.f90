! -----------------------------------------------------------------------------
! 07_assignment_overloading.f90 - interface assignment(=)
!
! Run:  scripts/run.sh 12-procedures-interfaces/07_assignment_overloading.f90
! -----------------------------------------------------------------------------
!
!   interface assignment(=)
!     module procedure assign_from_string
!   end interface
!
! * Specifics are SUBROUTINES with exactly two arguments:
!     (intent(out) or intent(inout) LHS, intent(in) RHS)
! * Lets `var = expr` work between different types (here: a string into a
!   version type), or replaces intrinsic assignment of a derived type with
!   your own (e.g. to count copies, or deep-copy pointer components).
! * Defined assignment is NOT used for initialisation in declarations or
!   for structure constructors - only for assignment statements.
! * For type-bound defined assignment see chapter 19.

module version_mod
  implicit none (type, external)
  private
  public :: version, assignment(=)

  type :: version
    integer :: major = 0, minor = 0, patch = 0
  end type version

  interface assignment(=)
    module procedure from_string, to_string
  end interface

contains

  subroutine from_string(v, text)
    type(version), intent(out) :: v
    character(len=*), intent(in) :: text
    integer :: ios
    character(len=len(text)) :: work
    integer :: i

    work = text
    do i = 1, len(work)
      if (work(i:i) == '.') work(i:i) = ' '
    end do
    read (work, *, iostat=ios) v%major, v%minor, v%patch
    if (ios /= 0) v = version()
  end subroutine from_string

  subroutine to_string(text, v)
    character(len=:), allocatable, intent(out) :: text
    type(version), intent(in) :: v
    character(len=40) :: buffer
    write (buffer, '(i0, ".", i0, ".", i0)') v%major, v%minor, v%patch
    text = trim(buffer)
  end subroutine to_string

end module version_mod

program assignment_overloading
  use version_mod, only: version, assignment(=)
  implicit none (type, external)

  type(version) :: v
  character(len=:), allocatable :: text

  v = '15.2.0'                 ! calls from_string
  print '(a, 3(1x, i0))', 'parsed:', v%major, v%minor, v%patch

  v%minor = v%minor + 1
  text = v                     ! calls to_string
  print '(2a)', 'formatted: ', text

  v = 'not a version'
  print '(a, 3(1x, i0))', 'bad input gives:', v%major, v%minor, v%patch

end program assignment_overloading

! Output:
! parsed: 15 2 0
! formatted: 15.3.0
! bad input gives: 0 0 0
