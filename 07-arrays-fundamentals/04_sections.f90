! -----------------------------------------------------------------------------
! 04_sections.f90 - array sections, strides and vector subscripts
!
! Run:  scripts/run.sh 07-arrays-fundamentals/04_sections.f90
! -----------------------------------------------------------------------------
!
! A section selects part of an array; it is itself an array (a variable if
! it can be assigned to).
!
!   a(lo:hi)        elements lo..hi            a(:)      all
!   a(lo:hi:s)      every s-th element         a(::2)    odd positions
!   a(hi:lo:-1)     reversed                   a(lo:)    lo to the end
!   m(i, :)         row i      (rank reduced from 2 to 1)
!   m(:, j)         column j
!   m(1:2, 2:3)     2x2 block  (rank stays 2)
!   a([3, 1, 2])    VECTOR SUBSCRIPT: arbitrary elements, any order
!
! Rules:
!   * A scalar subscript removes that dimension from the result's rank.
!   * A section's lower bounds are always 1, whatever the original bounds.
!   * An empty triplet (lo > hi with positive stride) gives a zero-sized
!     section - not an error.
!   * A vector-subscripted section with DUPLICATE indices must not be
!     assigned to (which element would win?). Such sections are also not
!     allowed as actual arguments to intent(out/inout) dummies.

program sections
  implicit none (type, external)

  integer :: a(10), m(3, 4), i
  integer, allocatable :: picked(:)

  a = [(i, i = 1, 10)]
  m = reshape([(i, i = 1, 12)], shape(m))

  print '(a, *(1x, i0))', 'a(3:6)       :', a(3:6)
  print '(a, *(1x, i0))', 'a(::2)       :', a(::2)
  print '(a, *(1x, i0))', 'a(10:1:-3)   :', a(10:1:-3)
  print '(a, *(1x, i0))', 'a(8:)        :', a(8:)
  print '(a, i0)',        'size(a(5:4)) : ', size(a(5:4))

  print '(a, *(1x, i0))', 'm(2, :)      :', m(2, :)
  print '(a, *(1x, i0))', 'm(:, 3)      :', m(:, 3)
  print '(a, *(1x, i0))', 'shape(m(1:2, 2:3)):', shape(m(1:2, 2:3))
  print '(a, *(1x, i0))', 'shape(m(2, 2:3))  :', shape(m(2, 2:3))

  ! Vector subscripts.
  picked = a([10, 1, 5, 5])
  print '(a, *(1x, i0))', 'a([10,1,5,5]):', picked

  ! Assigning through sections.
  a(1:5) = 0
  a(::3) = -1
  print '(a, *(1x, i0))', 'after updates:', a

  ! Assigning through a vector subscript (no duplicates allowed).
  a([2, 4, 6]) = [200, 400, 600]
  print '(a, *(1x, i0))', 'vector assign:', a

  ! Reverse in place: RHS is evaluated before assignment.
  a = a(size(a):1:-1)
  print '(a, *(1x, i0))', 'reversed     :', a

  ! Sections of a custom-bounds array start at 1.
  block
    integer :: z(-2:2)
    z = [(i, i = -2, 2)]
    print '(a, i0, 1x, i0)', 'lbound(z), lbound(z(-1:)) : ', lbound(z), lbound(z(-1:))
  end block

end program sections

! Output:
! a(3:6)       : 3 4 5 6
! a(::2)       : 1 3 5 7 9
! a(10:1:-3)   : 10 7 4 1
! a(8:)        : 8 9 10
! size(a(5:4)) : 0
! m(2, :)      : 2 5 8 11
! m(:, 3)      : 7 8 9
! shape(m(1:2, 2:3)): 2 2
! shape(m(2, 2:3))  : 2
! a([10,1,5,5]): 10 1 5 5
! after updates: -1 0 0 -1 0 6 -1 8 9 -1
! vector assign: -1 200 0 400 0 600 -1 8 9 -1
! reversed     : -1 9 8 -1 600 0 400 0 200 -1
! lbound(z), lbound(z(-1:)) : -2 1
