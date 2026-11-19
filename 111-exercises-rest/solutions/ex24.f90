! Exercise 24: iostat from a bad read, and stat from allocate.
program ex24
  implicit none (type, external)

  character(len=4) :: text
  integer :: n, ios, stat
  integer, allocatable :: values(:)

  text = 'nope'
  read (text, *, iostat=ios) n
  allocate (values(3), stat=stat)
  print '(a, l1)', 'bad read: ', ios /= 0
  print '(a, l1)', 'allocated: ', stat == 0

end program ex24

! Output:
! bad read: T
! allocated: T
