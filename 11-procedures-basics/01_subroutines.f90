! -----------------------------------------------------------------------------
! 01_subroutines.f90 - defining and calling subroutines
!
! Run:  scripts/run.sh 11-procedures-basics/01_subroutines.f90
! -----------------------------------------------------------------------------
!
!   subroutine name(dummy-args)
!     declarations of the dummy arguments and locals
!     executable statements
!   end subroutine name
!
!   call name(actual-args)
!
! * A subroutine has no result; it communicates through its arguments
!   (and, sparingly, module variables).
! * Arguments are associated with the caller's variables ("pass by
!   reference" in effect): assigning to a dummy changes the actual argument,
!   unless the dummy has the VALUE attribute.
! * RETURN leaves the subroutine early. Reaching END SUBROUTINE also returns.
! * A subroutine with no arguments can be called as `call name` or
!   `call name()`.
!
! Put procedures in a MODULE (as here) or after CONTAINS; then the compiler
! checks every call against the definition.

module geometry
  implicit none (type, external)
contains

  subroutine swap(a, b)
    real, intent(inout) :: a, b
    real :: tmp

    tmp = a
    a = b
    b = tmp
  end subroutine swap

  subroutine polar(x, y, r, theta)
    real, intent(in) :: x, y
    real, intent(out) :: r, theta

    r = hypot(x, y)
    theta = atan2(y, x)
  end subroutine polar

  subroutine print_positive(x)
    real, intent(in) :: x

    if (x <= 0) then
      print '(a)', '  (not positive, returning early)'
      return
    end if
    print '(a, f0.3)', '  positive value: ', x
  end subroutine print_positive

  subroutine hello
    print '(a)', 'hello from a subroutine without arguments'
  end subroutine hello

end module geometry

program subroutines
  use geometry, only: swap, polar, print_positive, hello
  implicit none (type, external)

  real :: a, b, r, theta

  a = 1.0
  b = 2.0
  call swap(a, b)
  print '(a, f0.1, 1x, f0.1)', 'after swap: ', a, b

  call polar(1.0, 1.0, r, theta)
  print '(a, f0.4, a, f0.4)', 'polar(1,1): r = ', r, ', theta = ', theta

  call print_positive(3.0)
  call print_positive(-1.0)

  call hello
  call hello()

end program subroutines

! Output:
! after swap: 2.0 1.0
! polar(1,1): r = 1.4142, theta = .7854
!   positive value: 3.000
!   (not positive, returning early)
! hello from a subroutine without arguments
! hello from a subroutine without arguments
