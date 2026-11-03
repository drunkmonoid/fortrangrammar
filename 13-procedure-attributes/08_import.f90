! -----------------------------------------------------------------------------
! 08_import.f90 - IMPORT in interface bodies (F2003)
!
! Run:  scripts/run.sh 13-procedure-attributes/08_import.f90
! -----------------------------------------------------------------------------
!
! An interface body is its own scoping unit and does NOT see the names of
! its host. Without IMPORT, an interface body inside a module could not
! even mention the module's own derived types or kind parameters.
!
!   import                    import every host entity (F2003)
!   import :: wp, point       import just these names (F2003)
!
! F2018 adds IMPORT, ONLY / NONE / ALL and allows IMPORT in contained
! procedures and BLOCKs too - see 09_import_f2018.f90.

module shapes
  use, intrinsic :: iso_fortran_env, only: real64
  implicit none (type, external)

  integer, parameter :: wp = real64

  type :: point
    real(wp) :: x = 0, y = 0
  end type point

  abstract interface
    function transform(p) result(q)
      import :: point                   ! without this, point is unknown
      type(point), intent(in) :: p
      type(point) :: q
    end function transform

    real(wp) function metric(a, b)
      import                            ! import everything from the host
      type(point), intent(in) :: a, b
    end function metric
  end interface

contains

  function mirror(p) result(q)
    type(point), intent(in) :: p
    type(point) :: q
    q = point(-p%x, p%y)
  end function mirror

  real(wp) function manhattan(a, b)
    type(point), intent(in) :: a, b
    manhattan = abs(a%x - b%x) + abs(a%y - b%y)
  end function manhattan

  subroutine report(p, f, d)
    type(point), intent(in) :: p
    procedure(transform) :: f
    procedure(metric) :: d
    type(point) :: q
    q = f(p)
    print '(a, 2(1x, f0.1), a, f0.1)', 'transformed:', q, '  distance: ', d(p, q)
  end subroutine report

end module shapes

program import_demo
  use shapes, only: point, mirror, manhattan, report
  implicit none (type, external)

  call report(point(3, 4), mirror, manhattan)

end program import_demo

! Output:
! transformed: -3.0 4.0  distance: 6.0
