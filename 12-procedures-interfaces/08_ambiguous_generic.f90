! @build fail
! -----------------------------------------------------------------------------
! 08_ambiguous_generic.f90 - specifics that cannot be told apart
!
! Try: scripts/run.sh 12-procedures-interfaces/08_ambiguous_generic.f90
! -----------------------------------------------------------------------------
!
! Two specific procedures in one generic must be distinguishable for EVERY
! possible call. These two are not: a call `show(1)` could mean either,
! because the second argument of show_b is optional. The compiler must
! reject the generic itself, not just the ambiguous call.
!
! gfortran reports something like:
!   Error: Ambiguous interfaces in generic interface 'show' for 'show_a'
!          at (1) and 'show_b' at (2)
!
! Fix: make the types differ in a non-optional position, give the optional
! argument its own required specific, or use different generic names.

module ambiguous
  implicit none (type, external)

  interface show
    module procedure show_a, show_b
  end interface

contains

  subroutine show_a(n)
    integer, intent(in) :: n
    print *, n
  end subroutine show_a

  subroutine show_b(n, width)
    integer, intent(in) :: n
    integer, intent(in), optional :: width
    print *, n, present(width)
  end subroutine show_b

end module ambiguous

program ambiguous_generic
  use ambiguous, only: show
  implicit none (type, external)

  call show(1)

end program ambiguous_generic
