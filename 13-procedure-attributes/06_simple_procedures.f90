! @build skip F2023 simple procedures are not implemented in gfortran 15
! -----------------------------------------------------------------------------
! 06_simple_procedures.f90 - SIMPLE procedures (F2023)
!
! Run:  needs a compiler with F2023 SIMPLE
! -----------------------------------------------------------------------------
!
! SIMPLE is a stronger form of PURE. A simple procedure may not REFERENCE
! (not even read) any variable outside its own scope except through its
! arguments: no module variables, no host variables, no COMMON. Its result
! depends only on its arguments, so calls with equal arguments give equal
! results and can be memoised, hoisted out of loops or evaluated anywhere.
!
!   simple ⊂ pure          a simple procedure is pure;
!                          it may call only simple procedures.
!
! Many intrinsic procedures are simple (sin, sqrt, ...).

module simple_demo
  implicit none (type, external)
  real :: offset = 1.0
contains

  simple real function scaled(x, factor)
    real, intent(in) :: x, factor
    scaled = x * factor
  end function scaled

  pure real function shifted(x)        ! pure: may READ module variables
    real, intent(in) :: x
    shifted = x + offset
  end function shifted

  ! simple real function bad(x)        ! error: references `offset`
  !   real, intent(in) :: x
  !   bad = x + offset
  ! end function bad

end module simple_demo

program simple_procedures
  use simple_demo, only: scaled, shifted
  implicit none (type, external)

  print '(a, f0.1)', 'scaled(2, 3) = ', scaled(2.0, 3.0)
  print '(a, f0.1)', 'shifted(2)   = ', shifted(2.0)

end program simple_procedures
