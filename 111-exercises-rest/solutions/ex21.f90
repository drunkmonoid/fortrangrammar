! Exercise 21: a pointer to a target section, then nullify.
program ex21
  implicit none (type, external)

  integer, target :: a(5)
  integer, pointer :: p(:)

  a = [1, 2, 3, 4, 5]
  p => a(2:4)
  print '(a, l1)', 'associated: ', associated(p)
  print '(a, i0)', 'sum = ', sum(p)
  nullify (p)
  print '(a, l1)', 'after nullify: ', associated(p)

end program ex21

! Output:
! associated: T
! sum = 9
! after nullify: F
