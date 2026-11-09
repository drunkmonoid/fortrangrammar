! -----------------------------------------------------------------------------
! 03_equivalence.f90 - EQUIVALENCE overlays two arrays
!
! Run:  scripts/run.sh 32-storage-association/03_equivalence.f90
! -----------------------------------------------------------------------------
!
!   equivalence (a(2), b(1))
!
! a(2) and b(1) are the same memory. b(2) is a(3), b(3) is a(4). Writing
! either name writes the other. This was a way to view one buffer as two
! arrays, and a reliable source of aliases the compiler will not track.
!
! Use one array and an index. Use transfer (chapter 26) when the goal is
! to reinterpret bits, and keep that rare.

program equivalence_demo
  implicit none (type, external)

  integer :: a(4), b(3)
  equivalence (a(2), b(1))

  a = [1, 2, 3, 4]
  b(1) = 9

  print '(a, 4(1x, i0))', 'a =', a
  print '(a, 3(1x, i0))', 'b =', b

end program equivalence_demo

! Output:
! a = 1 9 3 4
! b = 9 3 4
