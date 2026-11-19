! Exercise 33: a statement function and a labelled do.
program ex33
  implicit none (type, external)

  integer :: square, k, i, total
  square(k) = k * k

  total = 0
  do 10 i = 1, 3
    total = total + i
10 continue
  print '(a, i0, 1x, i0)', 'forms = ', square(5), total

end program ex33

! Output:
! forms = 25 6
