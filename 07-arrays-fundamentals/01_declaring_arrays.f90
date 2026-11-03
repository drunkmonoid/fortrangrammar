! -----------------------------------------------------------------------------
! 01_declaring_arrays.f90 - rank, bounds, extent, shape, size
!
! Run:  scripts/run.sh 07-arrays-fundamentals/01_declaring_arrays.f90
! -----------------------------------------------------------------------------
!
! Vocabulary:
!   rank    number of dimensions (0 = scalar, max 15)
!   bounds  lower:upper index per dimension; lower defaults to 1
!   extent  number of elements along one dimension = upper - lower + 1
!   shape   rank-1 integer array of the extents
!   size    total number of elements = product(shape)
!
! Declarations (all equivalent ways of giving the shape):
!   real :: a(10)               real, dimension(10) :: a
!   real :: b(0:9)              custom lower bound
!   real :: c(-5:5, 3)          rank 2, first dimension -5..5
!
! An upper bound below the lower bound gives extent 0: a ZERO-SIZED array.
! Zero-sized arrays are perfectly legal and make edge cases disappear
! (sum of an empty array is 0, loops over it run zero times).

program declaring_arrays
  implicit none (type, external)

  real :: a(10)
  real, dimension(10) :: same_as_a
  integer :: b(0:9)                 ! C-style 0-based indexing
  real :: c(-5:5, 3)                ! 11 x 3
  logical :: flags(2, 2, 2)         ! rank 3
  integer :: empty(1:0)             ! zero-sized
  integer, parameter :: r15(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) = 7
  integer :: i

  a = 1.0
  same_as_a = 2.0
  b = [(i * 10, i = 0, 9)]
  c = 0.0
  flags = .false.

  print '(a, i0)', 'rank(a)  = ', rank(a)
  print '(a, i0)', 'size(a)  = ', size(a)
  print '(a, i0, 1x, i0)', 'bounds of b: ', lbound(b), ubound(b)
  print '(a, i0)', 'b(0)     = ', b(0)
  print '(a, *(1x, i0))', 'shape(c) =', shape(c)
  print '(a, *(1x, i0))', 'lbound(c)=', lbound(c)
  print '(a, *(1x, i0))', 'ubound(c)=', ubound(c)
  print '(a, i0)', 'size(c, dim=1) = ', size(c, dim=1)
  print '(a, i0)', 'size(flags)    = ', size(flags)
  print '(a, i0, a, i0)', 'size(empty) = ', size(empty), ', sum(empty) = ', sum(empty)
  print '(a, i0, a, i0)', 'rank-15 constant: rank ', rank(r15), ', value ', r15(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)
  print '(a, f0.1)', 'same_as_a(10) = ', same_as_a(10)

end program declaring_arrays

! Output:
! rank(a)  = 1
! size(a)  = 10
! bounds of b: 0 9
! b(0)     = 0
! shape(c) = 11 3
! lbound(c)= -5 1
! ubound(c)= 5 3
! size(c, dim=1) = 11
! size(flags)    = 8
! size(empty) = 0, sum(empty) = 0
! rank-15 constant: rank 15, value 7
! same_as_a(10) = 2.0
