! -----------------------------------------------------------------------------
! 04_optional_arguments.f90 - OPTIONAL and PRESENT
!
! Run:  scripts/run.sh 11-procedures-basics/04_optional_arguments.f90
! -----------------------------------------------------------------------------
!
!   real, intent(in), optional :: tol
!   if (present(tol)) ...
!
! * An absent optional argument must not be referenced or defined - only
!   passed on to another OPTIONAL dummy (where it is also absent) or tested
!   with present().
! * Fortran has no default values in the interface. The idiom is a local
!   variable set from the argument or a default.
! * Optional arguments after the first omitted one must be passed by
!   KEYWORD (05_keyword_arguments.f90).
! * Requires an explicit interface.
! * Do not write `if (present(x) .and. x > 0)` - no short-circuit
!   (chapter 05). F2023 conditional expressions help:
!   ( present(x) ? x : default ).
! * An optional intent(out) argument is a clean way to return extra,
!   rarely-needed results (here: the iteration count).
!
! Trap seen while writing this file: a function referenced INSIDE a
! print/write statement must not itself write to the same unit - that is
! "recursive I/O" and gfortran aborts at run time. Compute first, print after.

module optional_demo
  implicit none (type, external)
contains

  real function solve(a, tol, max_iter, iterations)
    real, intent(in) :: a
    real, intent(in), optional :: tol
    integer, intent(in), optional :: max_iter
    integer, intent(out), optional :: iterations
    real :: tol_, x
    integer :: max_iter_, i

    tol_ = 1.0e-6
    if (present(tol)) tol_ = tol
    max_iter_ = 100
    if (present(max_iter)) max_iter_ = max_iter

    x = a                              ! Newton iteration for sqrt(a)
    do i = 1, max_iter_
      if (abs(x * x - a) < tol_) exit
      x = 0.5 * (x + a / x)
    end do
    if (present(iterations)) iterations = i
    solve = x
  end function solve

  subroutine log_message(text, level)
    character(len=*), intent(in) :: text
    integer, intent(in), optional :: level

    call emit(text, level)             ! absent stays absent
  end subroutine log_message

  subroutine emit(text, level)
    character(len=*), intent(in) :: text
    integer, intent(in), optional :: level

    if (present(level)) then
      print '(a, i0, 2a)', '[level ', level, '] ', text
    else
      print '(2a)', '[default] ', text
    end if
  end subroutine emit

end module optional_demo

program optional_arguments
  use optional_demo, only: solve, log_message
  implicit none (type, external)

  real :: root
  integer :: used

  print '(a, f0.6)', 'sqrt(2)                   = ', solve(2.0)
  print '(a, f0.6)', 'sqrt(2), tol=1e-2         = ', solve(2.0, 1.0e-2)
  print '(a, f0.6)', 'sqrt(2), max_iter=2       = ', solve(2.0, max_iter=2)
  root = solve(2.0, iterations=used)
  print '(a, f0.6, a, i0)', 'sqrt(2), with iterations  = ', root, ' after ', used
  call log_message('no level given')
  call log_message('with a level', 3)

end program optional_arguments

! Output:
! sqrt(2)                   = 1.414214
! sqrt(2), tol=1e-2         = 1.416667
! sqrt(2), max_iter=2       = 1.416667
! sqrt(2), with iterations  = 1.414214 after 5
! [default] no level given
! [level 3] with a level
