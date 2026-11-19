! Exercise 36: allocated() before any reference. The sum happens after.
program ex36
  implicit none (type, external)

  integer, allocatable :: a(:)

  print '(a, l1)', 'before: ', allocated(a)
  allocate (a(3))
  a = [1, 2, 3]
  print '(a, l1, 1x, i0)', 'after: ', allocated(a), sum(a)

end program ex36

! Output:
! before: F
! after: T 6
