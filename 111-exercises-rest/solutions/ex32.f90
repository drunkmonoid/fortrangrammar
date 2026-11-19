! Exercise 32: a and b(1) are the same integer.
! Two names, one cell. The second element has a name of its own.
program ex32
  implicit none (type, external)

  integer :: a, b(2)
  equivalence (a, b(1))

  b(1) = 7
  b(2) = 8
  print '(a, i0, 1x, i0)', 'overlaid = ', a, b(2)

end program ex32

! Output:
! overlaid = 7 8
