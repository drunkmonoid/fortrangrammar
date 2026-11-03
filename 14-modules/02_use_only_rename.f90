! -----------------------------------------------------------------------------
! 02_use_only_rename.f90 - USE, ONLY and renaming
!
! Run:  scripts/run.sh 14-modules/02_use_only_rename.f90
! -----------------------------------------------------------------------------
!
!   use m                          everything public in m
!   use m, only: a, b              just a and b (recommended)
!   use m, local_name => a         everything, with a renamed
!   use m, only: x => a            just a, called x here
!   use m, only: operator(+)       a generic operator
!   use m, only: operator(.plus.) => operator(.add.)   rename an operator
!   use m, only: assignment(=)     defined assignment
!
! * ONLY makes every dependency visible at the top of the file and avoids
!   name clashes when modules grow. Always use it.
! * Two USE statements for the same module combine.
! * A name clash between two modules is only an error if the ambiguous
!   name is actually REFERENCED - rename one of them to resolve it.
! * Renaming changes the local name only; generic resolution is unaffected.

module metric
  implicit none (type, external)
  real, parameter :: g = 9.81            ! m/s^2
  interface operator(.add.)
    module procedure add_lengths
  end interface
contains
  real function add_lengths(a, b)
    real, intent(in) :: a, b
    add_lengths = a + b
  end function add_lengths
  real function to_unit(x)
    real, intent(in) :: x
    to_unit = x                          ! metres
  end function to_unit
end module metric

module imperial
  implicit none (type, external)
  real, parameter :: g = 32.17           ! ft/s^2  (same name as metric's g!)
contains
  real function to_unit(x)
    real, intent(in) :: x
    to_unit = x * 3.28084                ! metres -> feet
  end function to_unit
end module imperial

program use_only_rename
  use metric, only: g_si => g, operator(.plus.) => operator(.add.)
  use metric, only: metres => to_unit    ! a second USE of the same module
  use imperial, only: g_ft => g, feet => to_unit
  implicit none (type, external)

  print '(a, f0.2)', 'g (SI)       = ', g_si
  print '(a, f0.2)', 'g (imperial) = ', g_ft
  print '(a, f0.2)', '2 m .plus. 3 m = ', 2.0 .plus. 3.0
  print '(a, f0.2, a, f0.2, a)', '10 m = ', metres(10.0), ' m = ', feet(10.0), ' ft'

end program use_only_rename

! Output:
! g (SI)       = 9.81
! g (imperial) = 32.17
! 2 m .plus. 3 m = 5.00
! 10 m = 10.00 m = 32.81 ft
