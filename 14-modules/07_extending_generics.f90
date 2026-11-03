! -----------------------------------------------------------------------------
! 07_extending_generics.f90 - adding to a generic from another module
!
! Run:  scripts/run.sh 14-modules/07_extending_generics.f90
! -----------------------------------------------------------------------------
!
! A generic interface is open: any scope that can see it may add specifics
! with its own `interface name` block. A user of both modules sees ONE
! generic containing all specifics - as long as they remain
! distinguishable.
!
! This is how libraries let you plug your own types into their generics
! (e.g. a to_string, a serialise, an operator).

module base_print
  implicit none (type, external)
  private
  public :: show

  interface show
    module procedure show_int, show_real
  end interface

contains

  subroutine show_int(x)
    integer, intent(in) :: x
    print '(a, i0)', 'integer: ', x
  end subroutine show_int

  subroutine show_real(x)
    real, intent(in) :: x
    print '(a, f0.3)', 'real: ', x
  end subroutine show_real

end module base_print

module point_mod
  use base_print, only: show
  implicit none (type, external)
  private
  public :: point, show                   ! re-export the extended generic

  type :: point
    real :: x = 0, y = 0
  end type point

  interface show                          ! extend the generic from base_print
    module procedure show_point
  end interface

contains

  subroutine show_point(p)
    type(point), intent(in) :: p
    print '(a, f0.1, a, f0.1, a)', 'point: (', p%x, ', ', p%y, ')'
  end subroutine show_point

end module point_mod

program extending_generics
  use point_mod, only: point, show
  implicit none (type, external)

  call show(42)
  call show(2.5)
  call show(point(1.0, 2.0))

end program extending_generics

! Output:
! integer: 42
! real: 2.500
! point: (1.0, 2.0)
