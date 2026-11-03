! -----------------------------------------------------------------------------
! 03_realloc_on_assignment.f90 - automatic (re)allocation on assignment
!
! Run:  scripts/run.sh 08-arrays-dynamic/03_realloc_on_assignment.f90
! -----------------------------------------------------------------------------
!
! Since F2003, for an ALLOCATABLE variable on the left of intrinsic
! assignment:
!
!   * if it is unallocated, it is allocated to the shape of the RHS;
!   * if it is allocated with a DIFFERENT shape, it is deallocated and
!     reallocated to the RHS shape;
!   * if the shape matches, the existing storage is reused.
!   * Bounds: a newly allocated variable gets the lower bounds of the RHS
!     (1 for most expressions).
!
! Writing a SECTION - a(:) = rhs - suppresses reallocation: the shapes must
! then conform, as for a non-allocatable array.
!
! Appending with a = [a, x] is convenient but copies the whole array each
! time: O(n^2) in a loop. Grow geometrically instead (04_move_alloc.f90).

program realloc_on_assignment
  implicit none (type, external)

  integer, allocatable :: a(:)
  real, allocatable :: m(:, :)
  character(len=:), allocatable :: s
  integer :: i

  a = [1, 2, 3]                          ! allocated by assignment
  print '(a, i0)', 'size after a = [1,2,3]     : ', size(a)

  a = [a, 4, 5]                          ! reallocated larger
  print '(a, i0)', 'size after a = [a, 4, 5]   : ', size(a)

  a = a(2:3)                             ! reallocated smaller
  print '(a, *(1x, i0))', 'a = a(2:3)                 :', a

  a(:) = [7, 8]                          ! section: no reallocation
  print '(a, *(1x, i0))', 'a(:) = [7, 8]              :', a
  ! a(:) = [1, 2, 3]   <- shape mismatch error (no reallocation for sections)

  ! Rank-2: the shape follows the RHS.
  m = reshape([(real(i), i = 1, 6)], [2, 3])
  print '(a, *(1x, i0))', 'shape(m)                   :', shape(m)
  m = transpose(m)
  print '(a, *(1x, i0))', 'shape(m) after transpose   :', shape(m)

  ! Deferred-length strings follow the same rules.
  s = 'short'
  s = s // ' and now longer'
  print '(3a, i0)', '"', s, '" len = ', len(s)

  ! Building an array element by element (fine for small n).
  a = [integer ::]
  do i = 1, 5
    a = [a, i * i]
  end do
  print '(a, *(1x, i0))', 'built by appending         :', a

end program realloc_on_assignment

! Output:
! size after a = [1,2,3]     : 3
! size after a = [a, 4, 5]   : 5
! a = a(2:3)                 : 2 3
! a(:) = [7, 8]              : 7 8
! shape(m)                   : 2 3
! shape(m) after transpose   : 3 2
! "short and now longer" len = 20
! built by appending         : 1 4 9 16 25
