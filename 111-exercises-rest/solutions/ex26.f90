! Exercise 26: popcnt(7) is 3, trailz(8) is 3.
program ex26
  implicit none (type, external)

  print '(a, i0, 1x, i0)', 'bits = ', popcnt(7), trailz(8)

end program ex26

! Output:
! bits = 3 3
