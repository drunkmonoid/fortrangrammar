! -----------------------------------------------------------------------------
! 07_internal_procedures.f90 - procedures after CONTAINS, host association
!
! Run:  scripts/run.sh 11-procedures-basics/07_internal_procedures.f90
! -----------------------------------------------------------------------------
!
! A main program, module procedure or external procedure may CONTAIN
! internal procedures:
!   * they are visible only inside their host;
!   * they see the host's variables by HOST ASSOCIATION (no arguments
!     needed) - convenient, but a local declaration with the same name hides
!     the host's entity;
!   * they always have an explicit interface;
!   * they cannot contain further internal procedures (one level only);
!   * since F2008 they can be passed as actual arguments (e.g. a closure-
!     like integrand that uses host variables; see chapter 12).
!
! Use them for small helpers; prefer explicit arguments over relying on
! host variables for anything non-trivial.

program internal_procedures
  implicit none (type, external)

  real :: scale
  integer :: calls

  scale = 2.0
  calls = 0

  print '(a, f0.1)', 'scaled(3) = ', scaled(3.0)
  scale = 10.0
  print '(a, f0.1)', 'scaled(3) = ', scaled(3.0)    ! sees the new scale
  call shadowing()
  print '(a, i0)', 'calls = ', calls
  print '(a, f0.1)', 'scale in host still = ', scale

contains

  real function scaled(x)
    real, intent(in) :: x
    calls = calls + 1                   ! modifies the host variable
    scaled = scale * x
  end function scaled

  subroutine shadowing()
    real :: scale                       ! hides the host's scale
    scale = -1.0
    print '(a, f0.1)', 'local scale = ', scale
  end subroutine shadowing

end program internal_procedures

! Output:
! scaled(3) = 6.0
! scaled(3) = 30.0
! local scale = -1.0
! calls = 2
! scale in host still = 10.0
