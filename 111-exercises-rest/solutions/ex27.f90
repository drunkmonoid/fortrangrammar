! Exercise 27: c_sizeof and c_loc, with no C translation unit.
program ex27
  use, intrinsic :: iso_c_binding, only: c_associated, c_int, c_loc, c_sizeof
  implicit none (type, external)

  integer(c_int), target :: n

  n = 1
  print '(a, i0)', 'sizeof = ', c_sizeof(n)
  print '(a, l1)', 'located: ', c_associated(c_loc(n))

end program ex27

! Output:
! sizeof = 4
! located: T
