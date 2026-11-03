! -----------------------------------------------------------------------------
! 01_reductions.f90 - sum, product, maxval, minval, count, any, all
!
! Run:  scripts/run.sh 09-array-intrinsics/01_reductions.f90
! -----------------------------------------------------------------------------
!
! Reduction intrinsics collapse an array (or one dimension of it):
!
!   sum(array [, dim] [, mask])       product(array [, dim] [, mask])
!   maxval(array [, dim] [, mask])    minval(array [, dim] [, mask])
!   count(mask [, dim] [, kind])      any(mask [, dim])     all(mask [, dim])
!
! * Without DIM the result is a scalar.
! * With DIM=d the result has rank n-1: dimension d is reduced away.
! * MASK (same shape as array) selects which elements take part.
! * Empty sets give the identity of the operation:
!     sum -> 0, product -> 1, count -> 0, any -> .false., all -> .true.,
!     maxval -> the most negative representable value (integers: -huge-1),
!     minval -> the most positive one; for reals that may be -/+infinity.

program reductions
  implicit none (type, external)

  integer :: m(2, 3)
  real :: x(5)
  integer :: empty(0)

  m = reshape([1, 2, 3, 4, 5, 6], shape(m))     ! [1 3 5; 2 4 6]
  x = [3.0, -1.0, 4.0, -1.5, 9.0]

  print '(a, i0)', 'sum(m)              = ', sum(m)
  print '(a, *(1x, i0))', 'sum(m, dim=1)       =', sum(m, dim=1)
  print '(a, *(1x, i0))', 'sum(m, dim=2)       =', sum(m, dim=2)
  print '(a, i0)', 'product(m)          = ', product(m)
  print '(a, i0)', 'sum(m, mask=m > 2)  = ', sum(m, mask=m > 2)
  print '(a, *(1x, i0))', 'maxval(m, dim=2)    =', maxval(m, dim=2)
  print '(a, f0.1)', 'minval(x)           = ', minval(x)
  print '(a, f0.1)', 'maxval(x, x < 5)    = ', maxval(x, mask=x < 5)
  print '(a, i0)', 'count(x < 0)        = ', count(x < 0)
  print '(a, *(1x, i0))', 'count(m > 2, dim=1) =', count(m > 2, dim=1)
  print '(a, l1)', 'any(x > 8)          = ', any(x > 8)
  print '(a, l1)', 'all(x > 0)          = ', all(x > 0)
  print '(a, *(1x, l1))', 'all(m > 1, dim=1)   =', all(m > 1, dim=1)

  ! Identities for empty arrays.
  print '(a, i0, 1x, i0)', 'sum, product of [] = ', sum(empty), product(empty)
  print '(a, i0)', 'maxval of []        = ', maxval(empty)
  print '(a, l1, 1x, l1)', 'any, all of []      = ', any(empty > 0), all(empty > 0)

  ! Mean and variance from reductions.
  print '(a, f0.3)', 'mean(x)             = ', sum(x) / size(x)
  print '(a, f0.3)', 'variance(x)         = ', sum((x - sum(x) / size(x))**2) / (size(x) - 1)

end program reductions

! Output:
! sum(m)              = 21
! sum(m, dim=1)       = 3 7 11
! sum(m, dim=2)       = 9 12
! product(m)          = 720
! sum(m, mask=m > 2)  = 18
! maxval(m, dim=2)    = 5 6
! minval(x)           = -1.5
! maxval(x, x < 5)    = 4.0
! count(x < 0)        = 2
! count(m > 2, dim=1) = 0 2 2
! any(x > 8)          = T
! all(x > 0)          = F
! all(m > 1, dim=1)   = F T T
! sum, product of [] = 0 1
! maxval of []        = -2147483648
! any, all of []      = F T
! mean(x)             = 2.700
! variance(x)         = 18.200
