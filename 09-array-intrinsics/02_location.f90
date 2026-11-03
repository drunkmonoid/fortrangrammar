! -----------------------------------------------------------------------------
! 02_location.f90 - maxloc, minloc, findloc
!
! Run:  scripts/run.sh 09-array-intrinsics/02_location.f90
! -----------------------------------------------------------------------------
!
!   maxloc(array [, dim] [, mask] [, kind] [, back])
!   minloc(array [, dim] [, mask] [, kind] [, back])
!   findloc(array, value [, dim] [, mask] [, kind] [, back])     (F2008)
!
! * Without DIM the result is a RANK-1 array with one subscript per
!   dimension - even for a rank-1 array (so take element (1), or use
!   dim=1 to get a scalar).
! * Subscripts are counted from 1 regardless of the array's lower bounds!
!   Add lbound(a) - 1 to convert.
! * If several elements tie, the FIRST in element order is reported;
!   back=.true. (F2008) reports the last.
! * If nothing qualifies (empty array, all-false mask, value not found)
!   the result is 0.
! * findloc compares with == (or .eqv. for logicals).

program location
  implicit none (type, external)

  integer :: v(6) = [4, 9, 2, 9, 1, 2]
  integer :: m(2, 3) = reshape([5, 8, 1, 8, 3, 0], [2, 3])
  integer :: z(0:4) = [7, 3, 9, 3, 1]

  print '(a, *(1x, i0))', 'maxloc(v)              =', maxloc(v)
  print '(a, i0)',        'maxloc(v, dim=1)       = ', maxloc(v, dim=1)
  print '(a, i0)',        'maxloc(v, 1, back=T)   = ', maxloc(v, dim=1, back=.true.)
  print '(a, i0)',        'minloc(v, 1)           = ', minloc(v, dim=1)
  print '(a, i0)',        'minloc(v, 1, v > 1)    = ', minloc(v, dim=1, mask=v > 1)
  print '(a, i0)',        'findloc(v, 2, 1)       = ', findloc(v, 2, dim=1)
  print '(a, i0)',        'findloc(v, 2, 1, back) = ', findloc(v, 2, dim=1, back=.true.)
  print '(a, i0)',        'findloc(v, 42, 1)      = ', findloc(v, 42, dim=1)

  print '(a, *(1x, i0))', 'maxloc(m)              =', maxloc(m)
  print '(a, *(1x, i0))', 'maxloc(m, dim=1)       =', maxloc(m, dim=1)
  print '(a, *(1x, i0))', 'findloc(m, 8)          =', findloc(m, 8)

  ! Lower bounds are ignored: the result counts from 1.
  print '(a, i0)',        'maxloc of z(0:4)       = ', maxloc(z, dim=1)
  print '(a, i0)',        'as an index into z     = ', maxloc(z, dim=1) + lbound(z, 1) - 1

end program location

! Output:
! maxloc(v)              = 2
! maxloc(v, dim=1)       = 2
! maxloc(v, 1, back=T)   = 4
! minloc(v, 1)           = 5
! minloc(v, 1, v > 1)    = 3
! findloc(v, 2, 1)       = 3
! findloc(v, 2, 1, back) = 6
! findloc(v, 42, 1)      = 0
! maxloc(m)              = 2 1
! maxloc(m, dim=1)       = 2 2 1
! findloc(m, 8)          = 2 1
! maxloc of z(0:4)       = 3
! as an index into z     = 2
