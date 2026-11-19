! Exercise 23: a scratch file, rewind, and a second read.
program ex23
  implicit none (type, external)

  integer :: unit, a, b

  open (newunit=unit, status='scratch', form='formatted')
  write (unit, '(2i4)') 3, 4
  rewind (unit)
  read (unit, '(2i4)') a, b
  close (unit)
  print '(a, i0, 1x, i0)', 'pair = ', a, b

end program ex23

! Output:
! pair = 3 4
