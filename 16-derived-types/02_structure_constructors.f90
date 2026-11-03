! -----------------------------------------------------------------------------
! 02_structure_constructors.f90 - building values of a derived type
!
! Run:  scripts/run.sh 16-derived-types/02_structure_constructors.f90
! -----------------------------------------------------------------------------
!
!   type_name(v1, v2, ...)                 positional, in component order
!   type_name(comp=v, other=w)             keyword (F2003), any order
!   type_name(v1, comp3=w)                 mixed
!
! * Components with default initialisation may be omitted (F2003).
! * Values are converted as in assignment (integer -> real, padding...).
! * Allocatable components accept any conforming value, or null() to leave
!   them unallocated.
! * You can write your own "constructor": a generic interface with the SAME
!   NAME as the type. Calls that match a specific go to it; otherwise the
!   intrinsic structure constructor is used. This is how invariants (e.g.
!   validation, derived fields) are enforced at construction.

module dates
  implicit none (type, external)
  private
  public :: date, interval

  type :: date
    integer :: year = 1970, month = 1, day = 1
  end type date

  type :: interval
    real :: lo, hi
  end type interval

  ! Custom constructor: interval(centre, radius, ordered=.true.)
  interface interval
    module procedure interval_from_centre
  end interface

contains

  function interval_from_centre(centre, radius, ordered) result(r)
    real, intent(in) :: centre, radius
    logical, intent(in) :: ordered          ! extra argument makes it distinct
    type(interval) :: r
    r%lo = centre - abs(radius)
    r%hi = centre + abs(radius)
    if (.not. ordered) r = interval(r%hi, r%lo)   ! intrinsic constructor
  end function interval_from_centre

end module dates

program structure_constructors
  use dates, only: date, interval
  implicit none (type, external)

  type(date) :: d
  type(interval) :: i1, i2

  d = date(2026, 11, 3)
  print '(a, i0, "-", i2.2, "-", i2.2)', 'positional : ', d
  d = date(day=25, month=12, year=2023)
  print '(a, i0, "-", i2.2, "-", i2.2)', 'keywords   : ', d
  d = date(2000)
  print '(a, i0, "-", i2.2, "-", i2.2)', 'defaults   : ', d
  d = date(month=6)
  print '(a, i0, "-", i2.2, "-", i2.2)', 'month only : ', d

  i1 = interval(1, 3)                       ! intrinsic: integers converted
  i2 = interval(5.0, 0.5, .true.)           ! custom constructor
  print '(a, 2(1x, f0.2))', 'interval(1, 3)          =', i1
  print '(a, 2(1x, f0.2))', 'interval(5.0, 0.5, .t.) =', i2

end program structure_constructors

! Output:
! positional : 2026-11-03
! keywords   : 2023-12-25
! defaults   : 2000-01-01
! month only : 1970-06-01
! interval(1, 3)          = 1.00 3.00
! interval(5.0, 0.5, .t.) = 4.50 5.50
